# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Searching catalog' do
  context 'when successful' do
    before do
      stub_request(:get, 'https://searchworks.stanford.edu/?format=json&q=frog&rows=3')
        .to_return(status: 200, body:, headers: {})
    end

    let(:body) { JSON.dump({ response: { docs: [], pages: { total_count: 0 } } }) }

    it 'draws the page' do
      get '/all/catalog?q=frog'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('<turbo-frame id="catalog_module">')
    end
  end

  context 'with weird params' do
    before do
      stub_request(:get, 'https://searchworks.stanford.edu/?format=json&q=&rows=3')
        .to_return(status: 200, body:, headers: {})
    end

    # NOTE: there are no 'pages' in the response when you hit this Searchworks endpoint
    let(:body) { JSON.dump({ response: { docs: [], facets: {} } }) }

    it 'returns 0 results' do
      get '/all/catalog?q=&quot%3BClavin%2C%20Matthew%20J.%2C=&quot%3B='
      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include('<turbo-frame id="catalog_module">')
      expect(response.body).to include('There was an error retrieving your catalog results.')
    end
  end

  context 'when settings are not found' do
    it 'raises an error' do
      get '/all/bad?q=frog'
      expect(response).to have_http_status(:not_found)
    end
  end
end
