require 'forwardable'

module Zenhub2pivotal
  class Repository
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def csv
      issues.lazy.map(&:csv)
    end

    def client
      @client ||= Octokit::Client.new(access_token: Config.github_access_token)
    end

    def issues
      Enumerator.new do |yielder|
        IssueLoader.new(self).load_paginating do |issue_data|
          issue_data.each do |issue_datum|
            yielder << Issue.new(issue_datum)
          end
        end
      end
    end

    class IssueLoader
      extend Forwardable

      def_delegators :@repository, :client

      def initialize(repository)
        @repository = repository
      end

      def load_paginating(&block)
        client.issues(@repository.name)
        paginate(client.last_response, &block)
      end

      def paginate(response, &block)
        block.call(response.data)
        return unless response.rels[:next]
        paginate(response.rels[:next].get, &block)
      end
    end
  end
end
