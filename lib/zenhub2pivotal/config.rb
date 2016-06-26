require 'yaml'

module Zenhub2pivotal
  class Config
    def self.all
      YAML.load_file("#{Dir.pwd}/.zenhub2pivotal.yml")
    rescue => e
      $stderr.puts("Can't load configuration file: #{e.message}")
      nil
    end

    class << self
      %i[github_access_token zenhub_access_token pipelines].each do |method_name|
        define_method method_name do
          all[method_name.to_s]
        end
      end
    end
  end
end
