require 'spec_helper'

RSpec.describe Flickr::Image do
  subject { Flickr::Image.new(id: 13, server: 'testserver', farm: '03', secret: 'ts') }

  describe '#initialize' do
    it 'should generate image url' do
      expect(subject.url).to eq 'https://farm03.staticflickr.com/testserver/13_ts.jpg'
    end
  end

  describe '#read' do
    let(:response) { double(:response) }
    let(:blob) { double(:blob) }
    let(:image) { double(:image) }

    it 'should request the file and build image' do
      # requests flickr for image
      expect(Curl).to receive(:get).with('https://farm03.staticflickr.com/testserver/13_ts.jpg').and_return(response)
      # responses with blob
      expect(response).to receive(:body_str).and_return(blob)
      # builds an image from blob
      expect(Magick::Image).to receive(:from_blob).with(blob).and_return([image])
      # returns the image
      expect(subject.read).to eq image
    end
  end
end
