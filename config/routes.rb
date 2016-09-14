Rails.application.routes.draw do
  resources :players, :only => [:index, :show, :create] do
    resources :games, :only => [:create]
  end

  resources :games, :only => [:show]
end
