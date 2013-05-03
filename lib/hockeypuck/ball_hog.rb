class Hockeypuck
  class BallHog
    include Celluloid
    # Single player. Usual playing style. Like Downloading through browser.

    attr_reader :puck

    def initialize(puck)
      @puck = puck
    end

    def download
      File.open(puck.download_path, 'w+') do |file|
        puts "Writing file #{puck.download_path}"
        request_uri = puck.uri.request_uri
        response = puck.http.get(request_uri)

        file.write(response.body)
      end
    end

  end
end
