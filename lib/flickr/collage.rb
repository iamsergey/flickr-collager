module Flickr
  class Collage
    def initialize(images:, width:, height:, tile:, padding:) 
      @images = images
      @width = width
      @height = height
      @tile = tile
      @padding = padding
    end

    def generate(io = $stdout)
      tile = parse_tile
      geometry = "+#{@padding}+#{@padding}"

      thumb_width = @width / tile.x
      thumb_height = @height / tile.y

      list = Magick::ImageList.new
      list += @images.map { |image| image.resize_to_fill(thumb_width, thumb_height) }

      collage = list.montage do |m|
        m.tile = tile.origin
        m.geometry = geometry
      end

      collage.resize!(@width, @height)
      collage.format = 'jpeg'
      collage.write(io)
    end

    private

    def parse_tile
      x, y = @tile.split('x').map(&:to_i)
      OpenStruct.new(x: x, y: y, origin: @tile).freeze
    end
  end
end
