Rails.application.routes.draw do

  root to: 'landing#index'

get :about, to: 'static_pages#about'

resources :topics, except: [:show] do
  resources :posts, except: [:show] do
    resources :comments, except: [:show]
  end
end

#get :topics, to: 'topics#index'

#resources :posts

#get :posts, to: 'posts#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
