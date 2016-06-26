module Zenhub2pivotal
  class ZenHub
    def initialize(id)
      @id = id
    end

    def board
      @board ||= Board.new(client.board_data(@id).body)
    end

    def client
      @client ||= ZenhubRuby::Client.new(Config.zenhub_access_token)
    end

    class Board
      def initialize(data)
        @data = data
      end

      def pipelines
        @pipelines ||= Hash[
          @data['pipelines'].dup.map{|pipeline_data|
            [pipeline_data.delete('name'), pipeline_data]
          }
        ]
      end
    end
  end
end
