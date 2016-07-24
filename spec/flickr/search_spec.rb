require 'spec_helper'

RSpec.describe Flickr::Search do
  let(:keywords) { ['cat', 'dog', 'mouse'] }
  let(:images) { 3.times.map { double(:image) } }
  let(:responses) do
    [{ 'id' => 1, 'server' => 'test1', 'farm' => 1, 'secret' => 'secret1' },
     { 'id' => 2, 'server' => 'test2', 'farm' => 2, 'secret' => 'secret2' },
     { 'id' => 3, 'server' => 'test3', 'farm' => 3, 'secret' => 'secret3' }]
  end

  subject { Flickr::Search.new(keywords: keywords) }

  describe '#find' do
    it 'should find images by keywords' do
      # finds image options by keywords
      keywords.each_with_index do |keyword, i|
        expect(subject).to receive(:find_by_keyword).with(keyword).and_return(responses[i])
      end

      # builds image objects
      responses.each_with_index do |response, i|
        args = { id: response['id'],
                 server: response['server'],
                 farm: response['farm'],
                 secret: response['secret'] }

        expect(Flickr::Image).to receive(:new).with(args).and_return(images[i])
      end

      expect(subject.find).to eq images
    end
  end

  describe '#find_by_keyword' do
    let(:response) { double(:response) }
    let(:json) { double(:json) }
    let(:image) { double(:image) }
    let(:params) do
      { method: 'flickr.photos.search',
        text: 'sunshine',
        api_key: ENV['FLICKR_API_KEY'],
        sort: :relevance,
        format: :json,
        nojsoncallback: true }
    end

    it 'should find image by keyword' do
      # requests the image details
      expect(Curl).to receive(:get).with('https://api.flickr.com/services/rest', params).and_return(response)
      # responses with json
      expect(response).to receive(:body_str).and_return(json)
      # parses json response
      expect(JSON).to receive(:parse).with(json).and_return('photos' => {'photo' => [image]})
      # returns the image
      expect(subject.send(:find_by_keyword, 'sunshine')).to eq image
    end
  end
end
