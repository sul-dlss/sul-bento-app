# Uses the Blacklight JSON API to search and then extracts select Catalog fields
class CatalogSearchService < AbstractSearchService
  def initialize(options = {})
    options[:query_url] ||= Settings.CATALOG_QUERY_API_URL.to_s
    options[:response_class] ||= Response
    super
  end

  class Response < AbstractSearchService::Response
    HIGHLIGHTED_FACET_FIELD = 'format_main_ssim'.freeze
    QUERY_URL = Settings.CATALOG_QUERY_URL

    def total
      json['response']['pages']['total_count'].to_i
    end

    def results
      solr_docs = json['response']['docs']
      solr_docs.collect do |doc|
        result = AbstractSearchService::Result.new
        result.title = doc['title_display'] || doc['title_full_display']
        result.link = Settings.CATALOG_FETCH_URL.to_s % { id: doc['id'] }
        result.id = doc['id']
        result.description = doc['summary_display'].try(:join) || find_description_in_marcxml(doc['marcbib_xml'])
        result
      end
    end

    def facets
      json['response']['facets']
    end

    def database_results(q)
      hits = 0
      if highlighted_facet['items'].present?
        database = highlighted_facet['items'].find { |i| i['value'] == 'Database' }
        hits = database['hits'].to_i if database.present?
      end
      {
        hits: hits,
        link: QUERY_URL.to_s % { q: q } + '&f[format_main_ssim][]=Database'
      }
    end

    private

    def json
      @json ||= JSON.parse(@body)
    end

    def find_description_in_marcxml(xml)
      doc = Nokogiri::XML(xml)
      doc.xpath('/marc:collection/marc:record/marc:datafield[@tag="500" or @tag="520"]/marc:subfield[@code="a"]',
                '/marc:collection/marc:record/marc:datafield[@tag="920"]/marc:subfield[@code="b"]',
                'marc' => 'http://www.loc.gov/MARC21/slim').text
    end
  end
end
