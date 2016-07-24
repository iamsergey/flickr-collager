require 'spec_helper'

RSpec.describe Flickr::Dictionary do
  subject { Flickr::Dictionary.instance }

  describe '#sample' do
    it 'should use cache if cache is not empty' do
      subject.instance_variable_set('@cache', ['cat', 'dog', 'mouse'])
      # doesn't load words from file
      expect(subject).not_to receive(:load_and_cache!)
      # takes 2 sample words out of 3 from cache
      expect(subject.sample(2)).to eq ['dog', 'mouse']
      # leaves cache with 1 sample word
      expect(subject.instance_variable_get('@cache')).to eq ['cat']
    end

    it 'should load and cache if cache is empty' do
      subject.instance_variable_set('@cache', [])
      # loads words from file and caches them
      expect(subject).to receive(:load_and_cache!)
      expect(subject.sample).to be_empty
    end
  end

  describe '#load_and_cache!' do
    it 'should load words from file and cache them' do
      words = double(:words)
      # reads file
      expect(File).to receive(:open).with('/usr/share/dict/words').and_return(words)
      # takes 50 sample words
      expect(words).to receive(:sample).with(50).and_return(['mouse', 'cat', 'dog'])
      subject.send(:load_and_cache!)
      # caches them using instance var
      expect(subject.instance_variable_get('@cache')).to eq ['mouse', 'cat', 'dog']
    end
  end
end
