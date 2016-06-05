module Zenhub2pivotal
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      $stdout.puts 'Id,Title,Labels,Iteration,Iteration Start,Iteration End,Type,Estimate,Current State,Created at,Accepted at,Deadline,Requested By,Description,URL,Owned By,Comment'
      Repository.new(@argv.pop).csv.each do |line|
        $stdout.print line
      end
    end
  end
end
