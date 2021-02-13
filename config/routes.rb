Rails.application.routes.draw do
  resources :videos
  root 'home#index'
  devise_for :users


  namespace :api do
    namespace :v1 do
      controller :api do
      	match '/upload_files', to: "api#upload_files", via: :post
      	match '/get_current_user', to: "api#get_current_user", via: :get
        match '/get_files', to: "api#get_files", via: :get
        match '/search_files', to: "api#search_files", via: :get
        match '/get_file_details', to: "api#get_file_details", via: :get
        match '/toggle_file_favourite', to: "api#toggle_file_favourite", via: :patch
        match '/get_user_favourites', to: "api#get_user_favourites", via: :get
        match '/get_trending_image', to: "api#get_trending_image", via: :get
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
