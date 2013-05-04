class Hockeypuck
  class Coach

    attr_reader :puck, :team, :rules

    def initialize(puck)
      @name = 'Don Johnson'
      @puck = puck
    end

    def make_strategy_for(puck)
      if accepts_ranges? && !simple
        async_download
      else
        ball_hog.score!
      end
    end

    private

    def part_offset(part_size, part_num)
      [part_size * (part_num - 1), part_size * part_num]
    end

  end
end
