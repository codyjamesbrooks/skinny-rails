Rails.application.routes.draw do
  get'/' => 'slug#retrive'
  post '/' => 'slug#create'
end
 