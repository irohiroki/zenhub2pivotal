module Zenhub2pivotal
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      Main.new(@argv, $stdout).perform
    end
  end
end
