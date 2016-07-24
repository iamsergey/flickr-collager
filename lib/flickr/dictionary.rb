require 'singleton'

module Flickr
  class Dictionary
    include Singleton
    PATH = '/usr/share/dict/words'.freeze
    CACHE_SIZE = 50

    def initialize
      @cache = []
    end

    def sample(count = 1)
      load_and_cache! if @cache.empty?
      @cache.pop(count)
    end

    private

    def load_and_cache!
      keywords = File.open(PATH, &:readlines)
      @cache = keywords.sample(CACHE_SIZE).map(&:strip)
    end
  end
end
