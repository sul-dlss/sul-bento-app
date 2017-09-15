Rails.application.routes.draw do
  mount QuickSearch::Engine => "/"

  root to: 'quick_search/search#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
