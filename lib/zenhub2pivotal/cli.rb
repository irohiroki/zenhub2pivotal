module Zenhub2pivotal
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      Repository.new(@argv.pop).csv.each do |line|
        $stdout.print line
      end
    end
  end
end
