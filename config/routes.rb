Rails.application.routes.draw do
  resources :lists, only: %i[index show new create]
end
