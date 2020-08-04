# frozen_string_literal: true

module QuickSearch
  class LibraryWebsiteApiSearcher < QuickSearch::Searcher
    delegate :results, :total, :facets, to: :@response

    def search
      @response ||= ::LibraryWebsiteApiSearchService.new.search(q)
    end

    def loaded_link
      format(Settings.LIBRARY_WEBSITE_QUERY_API_URL.to_s, q: CGI.escape(q.to_s))
    end
  end
end
