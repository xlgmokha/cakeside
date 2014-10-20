Cake::Application.routes.draw do
  default_url_options(Rails.application.config.action_mailer.default_url_options)

  get "about_us" => "home#about_us"
  get "why_cakeside" => "home#why_cakeside"

  post 'comments', to: 'comments#create'

  resources :tutorials, only: [:index, :show] do
    get 'page/:page', action: :index, on: :collection
  end
  resources :tutorial_tags, only: [:index, :show], path: :tt do
    member do
      get 'page/:page', action: :show
    end
  end

  resources :cakes, only: [:index, :show], path: :cakes do
    resources :photos, only: [:index, :show]
    resources :favorites, only: [:index, :create]
    get 'page/:page', action: :index, on: :collection, as: :paginate
    collection do
      get :newest, action: 'index', sort: 'newest'
      get :oldest, action: 'index', sort: 'oldest'
    end
  end
  get '/categories/:category', to: 'cakes#index', as: :category
  get '/categories/:category/page/:page', to: 'cakes#index'
  get '/creations' => redirect('/cakes')
  get 'creations/:id', to: redirect('/cakes/%{id}')
  get 'creations/page/:page', to: redirect('/cakes/page/%{page}')

  resources :profiles, only: [:index, :show] do
    get 'page/:page', action: :index, on: :collection, as: :paginate
  end

  # /tags
  resources :creation_tags, only: [:index, :show], path: :t do
    member do
      get 'page/:page', action: :show
    end
  end
  get 'tags/:id' => 'creation_tags#show'

  resources :sessions, only: [:new, :create, :destroy]
  get "login" => "sessions#new"
  delete "logout" => "sessions#destroy", id: "me"

  # /search
  get "search" => 'search#index'

  resources :passwords, only: [:new, :create, :edit, :update]
  resource :registration, only: [:create]

  # sitemap
  get "/sitemap.xml", to: "sitemap#index", defaults: { format: :xml }

  root to: "cakes#index"

  namespace :api, defaults: { :format => 'json' }  do
    namespace :v1 do
      resources :cakes, only: [:index, :show, :create, :update, :destroy] do
        resources :photos, only: [:index, :show, :create]
      end
      resources :categories, only: [:index]
      resources :tutorials, only: [:index, :create]
      resources :profiles, only: [:show, :update]
      resources :logins, only: [:create]
    end
  end

  namespace :admin do
    root to: "users#index"
    resources :users, only: [:index, :show, :update]
    resources :jobs, only: [:index, :show, :update, :destroy]
    resources :activities, only: [:index]
    resources :subscriptions, only: [:index]
    resources :photos, only: [:index, :show, :update]
    resources :blobs, only: [:index, :show]
    resources :errors, only: [:index, :create]
    resources :sessions, only: [:index, :destroy]
    resources :products, only: [:index, :show]
  end

  namespace :my do
    get 'dashboard', to: 'dashboard#index'
    resources :favorites, only: [:index]
    resources :settings, only: [:index, :update]
    resources :passwords, only: [:index, :update]
    resources :avatars, only: [:new, :create]
    root to: "dashboard#index"
  end
end
