class Hockeypuck
  class Config

    OPTIONS = [:storage_format, :storage_path]

    attr_accessor *OPTIONS

    def initialize(*args, &block)
      yield block if block

      if args.count > 1
        while args.count > 2 && args.count % 2 == 0
          set_option args.shift(2)
        end
      else
        if args[0].is_a? Hash
          args.each do |key, val|
            set_option key, val
          end
        end
      end
    end

    def self.from_file

    end

    private

    def set_option(key, val)
      if OPTIONS.include? key.to_sym
        self.key = val
      end
    end

  end
end
