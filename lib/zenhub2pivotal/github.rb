module Zenhub2pivotal
  class GitHub
    def self.client
      @client ||= Octokit::Client.new(access_token: Config.github_access_token)
    end

    def self.repository(name)
      Repository.new(name)
    end

    # TODO cache
    class IssueCache
      def initialize(repository)
        @repository = repository
      end

      def find_and_merge(zenhub_issue)
        issues.lazy.find{|issue|
          issue[:number] == zenhub_issue['issue_number']
        }.to_attrs.merge(zenhub_issue)
      end

      def issues
        Enumerator.new do |yielder|
          IssueLoader.new(@repository).load_paginating do |issue_data|
            issue_data.each do |issue_datum|
              yielder << issue_datum
            end
          end
        end
      end

      def load
        issues
      end
    end

    class IssueLoader
      def initialize(repository)
        @repository = repository
      end

      def load_paginating(&block)
        GitHub.client.issues(@repository.name)
        paginate(GitHub.client.last_response, &block)
      end

      def paginate(response, &block)
        block.call(response.data)
        return unless response.rels[:next]
        paginate(response.rels[:next].get, &block)
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
        IssueCache.new(self)
      end
    end
  end
end
