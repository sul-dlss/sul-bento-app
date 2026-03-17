# config/initializers/instrumentation.rb
ActiveSupport::Notifications.subscribe "external_api.call" do |name, start, finish, id, payload|
  duration = (finish - start) * 1000 # Duration in milliseconds

  Rails.logger.info "External API Call:"
  Rails.logger.info "  Event Name: #{name}"
  Rails.logger.info "  Duration: #{duration.round(2)}ms"
  Rails.logger.info "  Service: #{payload[:service]}"
  Rails.logger.info "  Query: #{payload[:query]}"
end

ActiveSupport::Notifications.subscribe "rerank" do |name, start, finish, id, payload|
  duration = (finish - start) * 1000 # Duration in milliseconds

  Rails.logger.info "Rerank:"
  Rails.logger.info "  Duration: #{duration.round(2)}ms"
  Rails.logger.info "  Size: #{payload[:size]}"
  Rails.logger.info "  Query: #{payload[:query]}"
end
