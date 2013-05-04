class Hockeypuck
  module List
    class << self

      attr_accessor :pucks, :ball_hog_pucks

      def add(puck, ball_hog)
        pucks ||= []
        ball_hog_pucks ||= []

        if ball_hog
          ball_hog_pucks << puck
        else
          pucks << puck
        end
      end

      def list(ball_hog = false)
        if ball_hog
          ball_hog_pucks
        else
          pucks
        end
      end

      def remove(puck)
        pucks.delete_if { |it| it == puck }
        ball_hog_pucks.delete_if { |it| it == puck }
      end

    end
  end
end
