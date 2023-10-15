Rails.application.routes.draw do
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
      post 'accept_new_participation', action: :accept_new_participation, as: :accept_new_participation
    end
  end
  root "pages#main_page"
  devise_for :users, controllers: { sessions: 'sessions' }

  resources :users, except: %i[update] do
    post :update, on: :member
    get :toggle_active_user, on: :member
    get :new_user_form, on: :collection
    post :auto_user_creation, on: :collection
  end
end
