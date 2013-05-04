class Hockeypuck
  module Coach

    class << self

      attr_reader :team, :pucks

      def name
        'Don Johnson'
      end

      def start!
        puck.rules.set_gates

        if accepts_ranges? && !simple
          async_download
        else
          ball_hog.score!
        end
      end

      def set_strategy_for(puck, ball_hog = false)
        hire_team unless team

        list.add puck, ball_hog or not accepts_passes?
      end

      def find_gates_for(puck)
        puck.rules.set_gates
      end

      private

      def part_offset(part_size, part_num)
        [part_size * (part_num - 1), part_size * part_num]
      end

    end

  end
end
