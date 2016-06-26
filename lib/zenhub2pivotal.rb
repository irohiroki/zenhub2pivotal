require 'octokit'
require 'zenhub_ruby'

require_relative 'zenhub2pivotal/cli'
require_relative 'zenhub2pivotal/config'
require_relative 'zenhub2pivotal/github'
require_relative 'zenhub2pivotal/issue'
require_relative 'zenhub2pivotal/repository'
require_relative 'zenhub2pivotal/version'
require_relative 'zenhub2pivotal/zenhub'

module Zenhub2pivotal
  class Main
    def initialize(repo_names, out)
      @repo_names = repo_names
      @out = out
    end

    def perform
      @out.puts 'Id,Title,Labels,Iteration,Iteration Start,Iteration End,Type,Estimate,Current State,Created at,Accepted at,Deadline,Requested By,Description,URL,Owned By,Comment'
      Config.pipelines.each do |pipeline_name, panel|
        repositories.flat_map {|repository|
          repository.issues(pipeline: pipeline_name)
        }.sort {
          0 # TODO
        }.each {|issue|
          @out.puts(issue.csv(panel: panel))
        }
      end
    end

    def repositories
      @repositories ||= @repo_names.map do |repo_name|
        Repository.new(repo_name)
      end
    end
  end
end
