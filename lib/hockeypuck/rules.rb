class Hockeypuck
  class Rules

    attr_accessor :download_path, :players,
      :http, :uri, :head, :size

    def initialize
      @download_path = '/tmp/downloads'
      @players = 6
      @uri, @http, @head, @size = nil
    end

    def set(uri, with_info = true, file_path = nil)
      @uri = URI path
      @http = Net::HTTP.new(uri.host, uri.port)
      @download_path = file_path || generate_path

      request_info! if with_info
    end

    def request_info!
      @head = http.request_head(uri.request_uri)
      @size = @head['Content-Length'].to_i
    end

    private

    def generate_path
      file_name = File.basename(uri.path)
      File.expand_path(file_name, Hockeypuck.rules.download_path)
    end

  end
end
