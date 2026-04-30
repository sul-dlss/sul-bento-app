class SearchController < ApplicationController
  allow_browser versions: :modern, block: :handle_outdated_browser
  rescue_from AbstractSearchService::NoResults, HTTP::TimeoutError, with: :handle_failed_search

  def index
    @query = params_q_scrubbed
    docs = Parallel.map(%w[catalog article archives exhibits earthworks library_website libguides], in_threads: 7) do |endpoint|
      ActiveSupport::Notifications.instrument('external_api.call', { query: @query, service: endpoint }) do
        service = Service.new(endpoint)
        response = service.search_service.search(@query)
        response.results
      end
    end.flatten

    Rails.logger.info 'results complete'
    rankable = docs.map { |doc| "#{doc.title} #{doc.description&.slice(0, 1500)}" }
    ranking = ActiveSupport::Notifications.instrument('rerank', { query: @query, size: rankable.size }) do
      SearchController.pipeline.call(@query, rankable)
    end
    @results = ranking.map { |r| docs[r.fetch(:index)] }
    @specialists = [] # Specialist.find(@query)&.first(3)
  end

  def show
    service = Service.new(params[:endpoint])

    result = service.search_service.search(params_q_scrubbed)
    @presenter = SearchPresenter.new(service, result, params_q_scrubbed)
  end

  def self.pipeline
    @pipeline ||= Transformers.pipeline('reranking', 'mixedbread-ai/mxbai-rerank-base-v1', device: 'mps')
  end

  private

  def handle_failed_search
    @service = Service.new(params[:endpoint])

    render 'failed_search', status: :internal_server_error
  end

  def handle_outdated_browser
    return if Rack::Attack.configuration.safelisted?(request)

    render file: Rails.public_path.join('406-unsupported-browser.html'), layout: false, status: :not_acceptable
  end

  def params_q_scrubbed
    params[:q]&.scrub
  end
end
