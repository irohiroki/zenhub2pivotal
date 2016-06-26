require 'forwardable'

module Zenhub2pivotal
  class Repository
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def board
      @board ||= ZenHub.new(id).board
    end

    def github_issues
      GitHub.repository(name).issues
    end

    def id
      GitHub.repository(name).id
    end

    def issues(pipeline:)
      pipeline_data(pipeline)['issues'].map do |zenhub_issue|
        Issue.new(github_issues.find_and_merge(zenhub_issue).merge(repo_name: name))
      end
    end

    private
      def pipeline_data(pipeline)
        board.pipelines[pipeline] or raise "No such pipeline: #{pipeline}"
      end
  end
end
