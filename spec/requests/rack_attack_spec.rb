# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rack::Attack nil IP handling' do
  before do
    allow(Rack::Attack).to receive(:enabled).and_return(true)
  end

  context 'when request has a nil IP due to malformed Forwarded header' do
    it 'blocks the request and returns 403 Forbidden' do
      get '/all', headers: { 'Forwarded' => 'by="[127.0.0.1]:1337";for="[127.0.0.1]:1337";proto=http;host=' }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
