Rails.application.routes.draw do
  resources :delivery_from_counterparties
  resources :product_sells do
    post :ajax_sell_price_request, on: :collection
  end

  resources :expenditures
  resources :combination_of_local_products
  resources :product_entries do
    get :define_product_destination, on: :collection
  end
  resources :buyers do
    post :toggle_active, on: :member
  end
  resources :providers do
    post :toggle_active, on: :member
  end
  resources :product_categories
  resources :products do
    post :toggle_active, on: :member
  end

  resources :salaries
  resources :teams do
    member do
      post :toggle_active
    end
  end
  resources :currency_rates
  resources :services do
    member do
      post :toggle_active
    end
  end

  resources :participations do
    collection do
      post "accept_new_participation", action: :accept_new_participation, as: :accept_new_participation
    end
  end
  root "pages#main_page"
  devise_for :users, controllers: { sessions: "sessions" }

  resources :users, except: %i[update] do
    post :update, on: :member
    get :toggle_active_user, on: :member
    get :new_user_form, on: :collection
    post :auto_user_creation, on: :collection
  end
end
