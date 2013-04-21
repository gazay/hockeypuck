require 'net'
autoload 'net/ftp'
autoload 'net/http'
autoload 'net/https'

class Hockeypuck
  class Player

    def pass(*args)
      if args.is_a?(Array) and args.first.is_a? Hockeypuck
      else
        puts 'WARNING: Partial downloading not yet implemented'
      end
    end

  end
end
