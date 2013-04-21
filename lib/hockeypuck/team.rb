class Hockeypuck
  class Team

    @list = []

    def initialize
    end

    class << self

      def play(puck)
        self.any.start puck
      end

    end

  end
end
