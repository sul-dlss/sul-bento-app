# frozen_string_literal: true

module ApplicationHelper
  def body_tag_attributes
    {
      data: {
        'quicksearch-ga-query': strip_tags(@log_query)
      }
    }
  end
end
