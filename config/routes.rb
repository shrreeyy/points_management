Rails.application.routes.draw do
  resources :users do
    collection do
      post 'register', to: 'users#register'
    end
    post 'credit', to: 'users#credit', on: :member
    post 'debit', to: 'users#debit', on: :member
  end
  resource :configurations, only: [:create, :show]
end
