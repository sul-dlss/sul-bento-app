# frozen_string_literal: true

class SearchResult
  include ActiveModel::API
  attr_accessor :title, :format, :icon, :physical, :author, :journal, :imprint, :issue, :description,
                :online_badge, :link, :thumbnail, :fulltext_link_html, :page_count, :page_start, :pub_date, :pub_year, :volume
end
