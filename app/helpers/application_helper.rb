# frozen_string_literal: true

module ApplicationHelper
  def render_module(searcher, service_name, partial_name = 'module', per_page = 3)
    if searcher
      render partial: partial_name , locals: { module_display_name: t("#{service_name}_search.display_name"), searcher: searcher, search: '', service_name: service_name, per_page: per_page }
    else
      content_tag :div, id: service_name, class: 'module-contents', tabindex: -1 do
        content_tag :p, '', class: 'search-error', data: { 'quicksearch-xhr-url' => xhr_search_path(service_name, q: params[:q]) }
      end
    end
  end
end
