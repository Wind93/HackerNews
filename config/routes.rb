Rails.application.routes.draw do
  get :detail, to: 'home#detail'
  root 'home#index'
end
