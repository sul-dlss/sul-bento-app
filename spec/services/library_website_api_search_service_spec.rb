# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LibraryWebsiteApiSearchService do
  subject(:service) { described_class.new }

  let(:response) do
    JSON.dump(
      {
        hits: [
          {
            title: 'Work with data',
            url: 'https://library.stanford.edu/services/work-data',
            summary: 'First result <b>description</b>',
            updated: 1_759_000_000,
            type: 'stanford_page',
            objectID: '2086'
          },
          {
            title: 'Promote your research',
            url: 'https://library.stanford.edu/services/promote-your-research',
            summary: 'this is a page that describes how Stanford Libraries can help students and scholars to promote their research',
            updated: 1_758_000_000,
            type: 'stanford_page',
            objectID: '2351'
          }
        ],
        nbHits: 207,
        page: 0,
        hitsPerPage: 3
      }
    )
  end
  let(:query) { 'chinese art' }

  let(:algolia_url) { Settings.library_website.api_url }

  before do
    stub_request(:post, algolia_url).to_return(body: response)
  end

  it { expect(service).to be_an AbstractSearchService }
  it { expect(service.search(query)).to be_an LibraryWebsiteApiSearchService::Response }

  describe '#search' do
    it 'POSTs the query to Algolia with the search-only credentials' do
      service.search(query)

      expect(
        a_request(:post, algolia_url)
          .with(
            body: { query: 'chinese art', hitsPerPage: 3 }.to_json,
            headers: {
              'X-Algolia-Application-Id' => 'PIE1C3NH1U',
              'X-Algolia-API-Key' => '480a02dab26ec59589f37014e3fd2f59'
            }
          )
      ).to have_been_made
    end

    context 'when the API returns an error' do
      before do
        stub_request(:post, algolia_url).to_return(status: 500, body: '{"message":"oops"}')
      end

      it 'raises NoResults' do
        expect { service.search(query) }.to raise_error(AbstractSearchService::NoResults)
      end
    end

    context 'when the API responds with 403 Forbidden' do
      before do
        stub_request(:post, algolia_url).to_return(status: 403)
      end

      it 'raises the HTTP status error' do
        expect { service.search(query) }.to raise_error(HTTP::StatusError, 'Unexpected status code 403')
      end
    end
  end

  describe '#records' do
    it 'sets the title, description, and link in the document' do
      results = service.search(query).results
      expect(results.length).to eq 2
      expect(results.first).to have_attributes(
        title: 'Work with data',
        description: 'First result description',
        link: 'https://library.stanford.edu/services/work-data'
      )
    end
  end

  describe '#total' do
    it 'returns the total' do
      count = service.search(query).total
      expect(count).to eq 207
    end
  end
end
