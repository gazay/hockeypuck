require 'celluloid'
require 'net/http'

autoload 'fileutils'

require_relative 'hockeypuck/rules'
require_relative 'hockeypuck/player'
require_relative 'hockeypuck/ball_hog'

class Hockeypuck

  class << self

    def add(path)
      puck = Hockeypuck.new path, with_info: true
      Hockeypuck::Coach.set_strategy_for puck
    end

    attr_reader :rules
    def set_rules
      @rules ||= Rules.new
      yield(@rules) if block_given?
    end

  end

  attr_reader :rules, :head, :size

  def initialize(path, opts = {})
    clone_rules
    rules.set path, file_path
    request_info! if opts[:with_info]
  end

  def start!(simple = false)
    if accepts_ranges? && !simple
      async_download
    else
      ball_hog.score!
    end
  end

  def ball_hog
    Hockeypuck::BallHog.
      new(self).
      async.
      download
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

  def accepts_ranges?
    head['Accept-Ranges'] == 'bytes'
  end

  private

  def clone_rules
    @rules = Hockeypuck.rules.clone
  end

  def request_info!
    @head = rules.http.request_head(uri.request_uri)
    @size = @head['Content-Length'].to_i
  end

end

Hockeypuck.set_rules
Puck = Hockeypuck
