Rails.application.routes.draw do
  get 'instances/usage' => 'instances#usage'
  post 'instances/:id' => 'instances#create'
end 
