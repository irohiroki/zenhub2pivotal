require 'csv'
require 'ostruct'

module Zenhub2pivotal
  class Issue
    def initialize(attrs)
      @attrs = attrs
    end

    def accepted_at
      format_time(:closed_at)
    end

    def assignee
      @attrs[:assignee][:login] if @attrs[:assignee]
    end

    def created_at
      format_time(:created_at)
    end

    def csv(panel: nil) # TODO
      CSV.generate do |csv|
        #       Id , Title, Labels, Iteration, Iteration Start, Iteration End, Type, Estimate, Current State, Created at, Accepted at, Deadline, Requested By, Description, URL, Owned By , Comment
        csv << [nil, title, labels, nil      , nil            , nil          , nil , nil     , state        , created_at, accepted_at, nil     , user_login  , body       , nil, assignee, nil]
      end
    end

    def labels
      @attrs[:labels].map{|label|
        label[:name]
      }.join(',') if @attrs[:labels]
    end

    def state
      case @attrs[:state]
      when 'closed'
        'accepted'
      when 'open'
        'unstarted'
      end
    end

    def user_login
      @attrs[:user][:login]
    end

    def method_missing(symbol, *args)
      if [:body, :title].include?(symbol)
        @attrs[symbol]
      else
        super
      end
    end

    private
      def format_time(key)
        @attrs[key].strftime('%b %-m, %Y') if @attrs[key]
      end
  end
end
