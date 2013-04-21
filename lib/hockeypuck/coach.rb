class Hockeypuck
  class Coach

    attr_reader :current_puck

    def initialize
      @name = 'Don Johnson'
    end

    def make_strategy_for(puck)
      @current_puck = puck
    end

    def between(players)
      part_size = players.count / @puck_size

      players.each_with_index do |player, part|
        player.pass @current_puck, part_offset(part_size, part)
      end
    end

    private

    def part_offset(part_size, part_num)
      [part_size * (part_num - 1), part_size * part_num]
    end

  end
end
