require 'spec_helper'

RSpec.describe Flickr::Collage do
  let(:io) { double(:io) }
  let(:list) { double(:image_list) }
  let(:collage) { double(:collage) }
  let(:images) { 6.times.map { double(:image) } }
  let(:resized_images) { 6.times.map { double(:resized_image) } }

  subject do
    Flickr::Collage.new images: images,
                        width: 1300,
                        height: 800,
                        tile: '3x2',
                        padding: 3
  end

  describe '#generate' do
    it 'should generate a collage' do
      # creates an image list
      expect(Magick::ImageList).to receive(:new).and_return(list)
      # resizes the images
      images.each_with_index do |image, i|
        expect(image).to receive(:resize_to_fill).with(433, 400).and_return(resized_images[i])
      end
      # adds resized images to the image list
      expect(list).to receive(:+).with(resized_images).and_return(list)
      # sets tile option for collage
      expect(collage).to receive(:tile=).with('3x2')
      # sets geometry option
      expect(collage).to receive(:geometry=).with('+3+3')
      # creates the collage
      expect(list).to receive(:montage).and_yield(collage).and_return(collage)
      # resizes the collage
      expect(collage).to receive(:resize!).with(1300, 800)
      # sets format to jpeg
      expect(collage).to receive(:format=).with('jpeg')
      # writes the collage to the specified IO
      expect(collage).to receive(:write).with(io)

      subject.generate(io)
    end

    context 'with fixture images' do
      let(:images) do
        blob = File.open('spec/fixtures/image.jpg', &:read)
        6.times.map { Magick::Image.from_blob(blob).first }
      end

      after do
        if File.exists?('spec/fixtures/collage.jpg')
          File.delete('spec/fixtures/collage.jpg')
        end
      end

      it 'should write collage to a file' do
        File.open('spec/fixtures/collage.jpg', 'wb') do |file|
          subject.generate(file)
        end

        collage_blob = File.open('spec/fixtures/collage.jpg', &:read)
        example_collage_blob = File.open('spec/fixtures/collage_example.jpg', &:read)

        collage = Magick::Image.from_blob(collage_blob).first
        collage_md5 = Digest::MD5.hexdigest(collage_blob)
        example_image_md5 = Digest::MD5.hexdigest(example_collage_blob)

        expect(collage_md5).to eq example_image_md5
        expect(collage.rows).to eq 800
        expect(collage.columns).to eq 1300
        collage.destroy!
      end
    end
  end
end
