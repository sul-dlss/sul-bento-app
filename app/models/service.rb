# frozen_string_literal: true

class Service
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def i18n_key
    @i18n_key ||= "#{@name}_search"
  end

  def settings
    @settings ||= Settings.public_send(@name)
  end

  def searcher
    "#{name.camelize}Searcher".constantize
  end
end
