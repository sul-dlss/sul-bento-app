# frozen_string_literal: true

# Does an HTTP request to the configured service endpoint.
class Service
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def display_name
    I18n.t('micro_display_name', scope: i18n.key, default: name)
  end

  def i18n_key
    name
  end

  def settings
    settings = Settings.public_send(@name)
    raise ActiveRecord::RecordNotFound, "Settings not found for #{@name}" unless settings

    settings
  end

  def search_service
    (settings.implementation || "#{name.camelize}SearchService").constantize.new
  end

  def see_all_url_template
    settings.query_url
  end
end
