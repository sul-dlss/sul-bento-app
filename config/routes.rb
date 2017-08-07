Rails.application.routes.draw do
  mount QuickSearch::Engine => "/"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/demo/article_search' => 'article#index'
  get '/demo/catalog_search' => 'catalog#index'
end
