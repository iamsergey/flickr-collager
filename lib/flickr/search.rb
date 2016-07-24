require 'json'

module Flickr
  class Search
    API_URL = 'https://api.flickr.com/services/rest'.freeze

    def initialize(keywords:)
      @keywords = keywords
    end

    def find
      results = @keywords.map { |keyword| find_by_keyword(keyword) }.compact
      results.map do |options|
        Image.new id: options['id'],
                  farm: options['farm'],
                  server: options['server'],
                  secret: options['secret']
      end
    end

    private

    def find_by_keyword(keyword)
      response = Curl.get API_URL, method: 'flickr.photos.search',
                                   text: keyword,
                                   api_key: ENV['FLICKR_API_KEY'],
                                   sort: :relevance,
                                   format: :json,
                                   nojsoncallback: true

      JSON.parse(response.body_str)['photos']['photo'].first
    end
  end
end
