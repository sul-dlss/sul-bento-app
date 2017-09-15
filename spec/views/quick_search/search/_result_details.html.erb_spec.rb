# frozen_string_literal: true

require 'rails_helper'

describe 'quick_search/search/_result_details.html.erb' do
  let(:result) do
    ArticleSearchService::Result.new.tap do |r|
      r.title = 'Title'
      r.link = 'http://example.com'
      r.description = 'The Description'
      r.fulltext_link_html = '<a href="#">Link</a>'
    end
  end
  before do
    without_partial_double_verification do
      allow(view).to receive(:result).and_return(result)
    end

    render
  end

  it 'links to the title' do
    within 'h3' do
      expect(rendered).to have_link('Title', href: 'http://example.com')
    end
  end

  it 'renders the description' do
    expect(rendered).to have_css('p', text: 'The Description')
  end

  it 'renders the fulltext link html' do
    within 'p' do
      expect(rendered).to have_link('Link', href: '#')
    end
  end
end