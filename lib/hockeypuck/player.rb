class Hockeypuck
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
end
