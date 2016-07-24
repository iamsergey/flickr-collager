require 'rmagick'
require 'curb'
require "flickr/collager/version"
require 'flickr/search'
require 'flickr/image'
require 'flickr/collage'
require 'flickr/dictionary'

module Flickr
  module Collager
    class << self
      DEFAULT_SIZE = 10
      DEFAULT_WIDTH = 1200
      DEFAULT_HEIGHT = 600
      DEFAULT_PADDING = 2
      DEFAULT_TILE = '5x2'.freeze

      def generate(keywords:, size: nil, width: nil, height: nil, padding: nil, tile: nil, io: $stdout)
        images = Search.new(keywords: keywords).find

        size ||= DEFAULT_SIZE
        while images.count < size
          random_keywords = Dictionary.instance.sample(size - images.count)
          images += Search.new(keywords: random_keywords).find
        end

        collage = Collage.new images: images.map(&:read),
                              width: width || DEFAULT_WIDTH,
                              height: height || DEFAULT_HEIGHT,
                              tile: tile || DEFAULT_TILE,
                              padding: padding || DEFAULT_PADDING

        collage.generate(io)
      end
    end
  end
end
