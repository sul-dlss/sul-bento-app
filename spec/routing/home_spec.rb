# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page' do
  it 'renders the home page' do
    expect(get: '/').to route_to('pages#home')
  end

  it 'renders the search page if a query string is provided' do
    expect(get: '/?q=blah').to route_to('search#index', q: 'blah')
  end

  context 'when the query has an array (e.g. q[]=x, sent by qualsys)' do
    it 'renders the home page' do
      expect(get: '/?q[]=x').to route_to('pages#home', q: ['x'])
    end
  end
end
