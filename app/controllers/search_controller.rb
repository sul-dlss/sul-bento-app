class SearchController < ApplicationController
  allow_browser versions: :modern, block: :handle_outdated_browser

  def index
    @query = params_q_scrubbed
  end

  def show
    service = Service.new(params[:endpoint])

    begin
      result = query(service, params_q_scrubbed)
      @presenter = SearchPresenter.new(service, result)
    rescue AbstractSearchService::NoResults
      @presenter = SearchPresenter.new(service, nil)
    end
  end

  BenchmarkLogger = ActiveSupport::Logger.new(Rails.root.join('log/benchmark.log'))
  BenchmarkLogger.formatter = Logger::Formatter.new

  private

  # @param [Service] service
  def query(service, query_text, timeout: 30)
    benchmark format("%s #{service.name}", CGI.escape(query_text)) do
      client = HTTP.timeout(timeout).headers(user_agent: "#{HTTP::Request::USER_AGENT} (#{Settings.user_agent})")

      service.searcher.new(client, query_text).tap(&:search)
    end
  end

  def benchmark(message)
    result = nil
    bench_result = Benchmark.realtime { result = yield }
    BenchmarkLogger.info format('%<message>s (%<time>.1fms)', message:, time: bench_result * 1000)
    result
  end

  def handle_outdated_browser
    return if Rack::Attack.configuration.safelisted?(request)

    render file: Rails.public_path.join('406-unsupported-browser.html'), layout: false, status: :not_acceptable
  end

  def params_q_scrubbed
    params[:q]&.scrub
  end

  def search_service
    SearchService.new(@query)
  end
end
