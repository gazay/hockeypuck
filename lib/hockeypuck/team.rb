require_relative 'player'

class Hockeypuck
  class Team

    cattr_accessor :list,
      instance_reader: false, instance_writer: false
    @@list = []

    attr_reader :coach, :players, :busy

    class << self

      def play(puck)
        self.any.start puck
      end

      def any
        team = @@teams.find { |t| t.free? }
        team = Team.new unless team

        team
      end

    end

    def initialize(players_count = Hockeypuck.config.players_count)
      self.busy = false

      self.coach = Hockeypuck::Coach.new
      self.players = []
      players_count.times do
        self.players << Hockeypuck::Player.new
      end

      self.class.teams << self
    end

    def start(puck)
      return false if busy
      self.busy = true

      coach.make_strategy_for(puck).between players
    end

    def busy?; !!busy; end
    def free?; !busy?; end

  end
end
