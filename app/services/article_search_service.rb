# frozen_string_literal: true

# Uses the Blacklight JSON API to search and then extracts select EDS fields
class ArticleSearchService < AbstractSearchService
  def initialize(options = {})
    options[:query_url] ||= Settings.ARTICLE.API_URL.to_s
    options[:response_class] ||= Response
    super
  end

  class Response < AbstractSearchService::Response
    HIGHLIGHTED_FACET_FIELD = 'eds_publication_type_facet'
    QUERY_URL = Settings.ARTICLE.QUERY_URL

    def total
      json['response']['pages']['total_count'].to_i
    end

    def results
      solr_docs = json['response']['docs']
      solr_docs.collect do |doc|
        result = AbstractSearchService::Result.new
        result.title = doc['eds_title']
        result.link = format(Settings.ARTICLE.FETCH_URL.to_s, id: doc['id'])
        result.id = doc['id']
        result.fulltext_link_html = doc['fulltext_link_html']
        result.author = doc['eds_authors']&.first
        result.imprint = doc['eds_composed_title']&.html_safe
        result.description = doc['eds_abstract']
        result
      end
    end

    def facets
      json['response']['facets']
    end

    private

    def json
      @json ||= JSON.parse(@body)
    end
  end
end
