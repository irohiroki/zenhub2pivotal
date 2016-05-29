require 'csv'
require 'ostruct'

module Zenhub2pivotal
  class Issue
    def initialize(attrs)
      @attrs = attrs
    end

    def csv
      CSV.generate do |csv|
        csv << [@attrs[:title]]
      end
    end
  end
end
