module Zenhub2pivotal
  class GitHub
    def self.client
      @client ||= Octokit::Client.new(access_token: Config.github_access_token)
    end

    def self.repository(name)
      @repositories ||= {}
      @repositories[name] ||= Repository.new(name)
    end

    class IssueCache
      def initialize(repository)
        @repository = repository
        @cache = []
      end

      def find_and_merge(zenhub_issue)
        issues.lazy.find{|issue|
          issue[:number] == zenhub_issue['issue_number']
        }.to_attrs.merge(zenhub_issue)
      end

      def issues
        Enumerator.new do |yielder|
          @cache.each do |issue_datum|
            yielder << issue_datum
          end

          loop do
            issue_data = loader.next
            break if issue_data.nil?
            @cache += issue_data
            issue_data.each do |issue_datum|
              yielder << issue_datum
            end
          end
        end
      end

      def load
        issues
      end

      def loader
        @loader ||= IssueLoader.new(@repository)
      end
    end

    class IssueLoader
      def initialize(repository)
        @repository = repository
      end

      def next
        if @response
          rel_next = @response.rels[:next]
          if rel_next
            @response = rel_next.get
            @response.data
          else
            nil
          end
        else
          GitHub.client.issues(@repository.name)
          @response = GitHub.client.last_response
          @response.data
        end
      end
    end

    class Repository
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def data
        @data ||= GitHub.client.repo(name)
      end

      def id
        data[:id]
      end

      def issues
        @issue_cache ||= IssueCache.new(self)
      end
    end
  end
end
