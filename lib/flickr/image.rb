module Flickr
  class Image
    URL_TEMPLATE = 'https://farm%s.staticflickr.com/%s/%s_%s.jpg'.freeze

    attr_reader :url

    def initialize(id:, farm:, server:, secret:)
      @url = URL_TEMPLATE % [farm, server, id, secret]
    end

    def read
      blob = Curl.get(url).body_str
      Magick::Image.from_blob(blob).first
    end
  end
end
