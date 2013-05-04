require 'net/http'
require 'fileutils'
require 'celluloid'
require_relative 'hockeypuck/rules'
require_relative 'hockeypuck/player'
require_relative 'hockeypuck/ball_hog'

class Hockeypuck

  class << self

    attr_reader :rules
    def set_rules
      @rules ||= Rules.new
      yield(@rules) if block_given?
    end

  end

  def initialize(uri, with_info = true, file_path = nil)
    clone_rules
    rules.set uri, with_info, file_path
  end

  attr_reader :rules
  def clone_rules
    @rules = Hockeypuck.rules.clone
  end

  def start!(simple = false)
    Hockeypuck.create_gates

    if accepts_ranges? && !simple
      async_download
    else
      ball_hog
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

end

Hockeypuck.set_rules
