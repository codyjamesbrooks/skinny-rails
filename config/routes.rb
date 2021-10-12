Rails.application.routes.draw do
  get '/', to: 'slug#index'
  post '/', to: 'slug#create'
  get'/:slug', to: 'slug#retrive'
  get '/stats/:slug', to: 'slug#stats'
end
 