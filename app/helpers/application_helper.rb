# frozen_string_literal: true

module ApplicationHelper
  def application_name
    I18n.t "defaults_search.title_name"
  end

  def organization_name
    I18n.t 'organization_name'
  end

  def body_class
    [controller_name, action_name].join('-')
  end

  def title(page_title = nil)
    query = @query.blank? ? "" : truncate(@query, length: 40, separator: ' ', escape: false)
    page_title ||= []
    page_title << "#{query} |" unless query.blank?
    page_title << " #{application_name} |" unless application_name.blank?
    page_title << " #{organization_name}" unless organization_name.blank?

    content_for :title, page_title.compact.join
  end

  # @param [ApplicationSearcher] searcher
  # @param [String] service_name
  def render_module(searcher, service_name)
    if searcher
      render 'module', { searcher: searcher, search: '', service_name: service_name }
    else
      content_tag :div, id: service_name, class: 'module-contents', tabindex: -1 do
        content_tag :p, '', class: 'search-error', data: { 'quicksearch-xhr-url' => xhr_search_path(service_name, q: params[:q]) }
      end
    end
  end

  def visually_hidden_service(service_name)
    tag.span service_name.humanize(capitalize: false), class: 'visually-hidden'
  end
end
