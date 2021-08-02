Rails.application.routes.draw do
  resources :fields, only: [:index]
  resources :crops, only: [:index]
  get "updatedHumusBalance/:fieldId/:cropVal/:cropYear", to: "fields#updated_humus_balance" 
end
