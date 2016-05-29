require 'yaml'

module Zenhub2pivotal
  class Config
    def self.all
      YAML.load_file("#{Dir.pwd}/.zenhub2pivotal.yml")
    rescue => e
      $stderr.puts("Can't load configuration file: #{e.message}")
      nil
    end

    def self.github_access_token
      all['github_access_token']
    end
  end
end
