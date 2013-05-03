require 'net/http'
require 'fileutils'
require 'celluloid'

class Player
  include Celluloid

  attr_reader :start, :finish, :downloaded, :path, :number, :finished

  def initialize(range, number, path)
    @start, @finish = range.split('-').map(&:to_i)
    @number = number
    @path = path
    @downloaded = 0
    @finished = false
  end

  def download(uri)
    puts "Writing file #{download_path}"
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri.request_uri
      request['Range'] = "bytes=#{start + downloaded}-#{finish}"
      http.request(request) do |resp|
        File.open(download_path, 'a') do |file|
          file.write resp.body
          #resp.read_body do |chunk|
            #file.write chunk
            #@downloaded += chunk.length
          #end
        end
      end
    end

    @finished = true
    puts "Finished file #{download_path}"
  end

  def download_path
    "#{path}_#{number}"
  end

end

class Hockeypuck

  attr_reader :uri, :http, :head, :size
  attr_accessor :download_path

  def initialize(path, file_path = nil)
    Hockeypuck.download_path

    @uri = URI path
    @http = Net::HTTP.new(uri.host, uri.port)
    @download_path = file_path || generate_path
  end

  def self.download_path
    unless defined?(@@download_path)
      download_path = '/tmp/downloads'
    else
      @@download_path
    end
  end

  def self.download_path=(value)
    puts "Download path now is #{value}"
    @@download_path = value
  end

  def self.players
    unless defined?(@@players)
      download_path = 20
    else
      @@players
    end
  end

  def self.players=(value)
    puts "Players amount #{value}"
    @@players = value
  end

  def self.create_directory
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

  def start!(simple = false)
    get_info
    Hockeypuck.create_directory

    if accepts_ranges? && !simple
      async_download
    else
      simple_download
    end
  end

  def async_download
    puts 'Start async'
    players = Hockeypuck.players
    part_size = (size / players).ceil
    parts = []
    players.times do |i|
      parts << [part_size * i, part_size * (i + 1) - 1]
    end
    parts.last[1] = size
    players = []
    parts.map { |it| it.join('-') }.each_with_index do |pl, ind|
      player = Player.new(pl, ind, download_path)
      player.async.download(uri)
      players << player
    end

    puts 'Finished async'
    until players.all?(&:finished) do
      sleep(1)
    end
    puts 'Start assembly file async'
    assembly_file
    puts 'Finished assembly file async'
  end

  def assembly_file
    File.open(download_path, 'w') do |file|
      Hockeypuck.players.times do |i|
        file.write File.read("#{download_path}_#{i}")
      end
    end
    "Downloading finished!!!"
  end

  def simple_download
    File.open(download_path, 'w+') do |f|
      puts "Writing file #{download_path}"
      f.write http.get(uri.request_uri).body
    end
  end

  def get_info
    @head = http.request_head(uri.request_uri)
    @size = @head['Content-Length'].to_i

    @head
  end

  def accepts_ranges?
    head['Accept-Ranges'] == 'bytes'
  end

  def generate_path
    file_name = File.basename(uri.path)
    File.expand_path(file_name, Hockeypuck.download_path)
  end

end
