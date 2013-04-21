require_relative 'hockeypuck/config'
require_relative 'hockeypuck/list'
require_relative 'hockeypuck/coach'
#require_relative 'hockeypuck/player'
require_relative 'hockeypuck/team'
#require_relative 'hockeypuck/rules'
#require_relative 'hockeypuck/part'

class Hockeypuck

  attr_accessor :path, :file_type, :storage_path

  def initialize(opts = {}, *args)
    @path = opts[:path] || args[0]
    @file_type = opts[:file_type] || args[1]
  end

  def start!(without_team = false)
    if without_team
      Hockeypuck::Player.new.pass(self)
    else
      Hockeypuck::Team.play self
    end
  end

  def self.fetch(file, options = {})
    options[:path] = file

    puck = self.new options
    puck.start!
  end

end
