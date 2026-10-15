# frozen_string_literal: true

# Uses the Algolia index of the Library Website to search
class LibraryWebsiteApiSearchService < AbstractSearchService
  def initialize(**)
    @query_url = Settings.library_website.api_url.to_s
    @response_class = Response
    super
  end

  class Response < AbstractSearchService::Response
    def results
      sanitizer = Rails::Html::FullSanitizer.new

      return unless json['hits']

      json['hits'].map do |hit|
        LibraryWebsiteResult.new(
          title: hit['title'],
          link: hit['url'],
          description: sanitizer.sanitize(hit['summary'])
        )
      end
    end

    def total
      json['nbHits']
    end
  end

  private

  def fetch(query)
    @http.headers(algolia_headers).post(@query_url, json: { query:, hitsPerPage: Settings.MAX_RESULTS })
  end

  def algolia_headers
    {
      'X-Algolia-Application-Id' => Settings.library_website.app_id,
      'X-Algolia-API-Key' => Settings.library_website.search_key
    }
  end
end
