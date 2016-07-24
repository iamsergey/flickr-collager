require 'spec_helper'

RSpec.describe Flickr::Collager do
  let(:images) { 4.times.map { double(:image) } }
  let(:loaded_images) { 4.times.map { double(:loaded_image) } }
  let(:searches) { 2.times.map { double(:search) }}
  let(:collage) { double(:collage) }
  let(:io) { double(:io) }

  describe '.generate' do
    it 'should generate a collage' do
      # searches for images by keywords
      expect(Flickr::Search).to receive(:new).with(keywords: ['cat', 'dog', 'mouse']).and_return(searches[0])
      # responses with images
      expect(searches[0]).to receive(:find).and_return(images[0..2])
      # gets random keyword from dictionary to get one more image
      expect(Flickr::Dictionary.instance).to receive(:sample).and_return(['rabbit'])
      # searches for image by this keyword
      expect(Flickr::Search).to receive(:new).with(keywords: ['rabbit']).and_return(searches[1])
      # responses with image
      expect(searches[1]).to receive(:find).and_return(images[3..3])
      # loads all the images from flickr
      images.each_with_index do |image, i|
        expect(image).to receive(:read).and_return(loaded_images[i])
      end
      # builds a collage object
      args = { images: loaded_images, width: 1000, height: 800, tile: '2x2', padding: 2 }
      expect(Flickr::Collage).to receive(:new).with(args).and_return(collage)
      # generates a collage
      expect(collage).to receive(:generate).with(io)

      Flickr::Collager.generate keywords: ['cat', 'dog', 'mouse'],
                                size: 4,
                                width: 1000,
                                height: 800,
                                tile: '2x2',
                                padding: 2,
                                io: io
    end
  end
end
