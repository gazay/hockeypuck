class Hockeypuck
  class Rules

    attr_accessor :download_path, :players,
      :http, :uri

    def initialize
      @download_path = '/tmp/downloads'
      @players = 6
    end

    def set(uri, file_path = nil)
      @uri = URI path
      @http = Net::HTTP.new(uri.host, uri.port)
      @download_path = file_path || generate_path
    end

    def set_gates
      puts 'Checking existance of directory'

      unless Dir.exists? download_path
        dirs = download_path.split('/')
        case dirs.first
        when '.'
          dirs[0] = Dir.pwd
        when '~'
          dirs[0] = `cd ~; pwd`.chop
        end

        dir_name = dirs.join('/')

        unless Dir.exists? dir_name
          puts "Creating directory with `mkdir -p #{dir_name}`"
          FileUtils.mkdir_p dir_name
        end
      end
    end

    private

    def generate_path
      file_name = File.basename(uri.path)
      File.expand_path(file_name, Hockeypuck.rules.download_path)
    end

  end
end
