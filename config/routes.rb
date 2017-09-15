Rails.application.routes.draw do
  resource :feedback_form, path: 'feedback', only: %i[new create]
  get 'feedback' => 'feedback_forms#new'

  mount QuickSearch::Engine => "/"

  root to: 'quick_search/search#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
