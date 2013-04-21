require_relative 'hockeypuck/config'
require_relative 'hockeypuck/list'
require_relative 'hockeypuck/coach'
#require_relative 'hockeypuck/player'
require_relative 'hockeypuck/team'
#require_relative 'hockeypuck/rules'
#require_relative 'hockeypuck/part'

class Hockeypuck

  attr_accessor :path, :file_type

  def initialize(opts = {}, *args)
    @path = opts[:path] || args[0]
    @file_type = opts[:file_type] || args[1]

    Hockeypuck::Team.play self
  end

  def fetch(file)
    begin

    end
  end

end
