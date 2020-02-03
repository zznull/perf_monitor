Rails.application.routes.draw do
  get '/tests' => 'tested_urls#index'
  get '/tests/last' => 'tested_urls#last'
  post '/test' => 'tested_urls#create'
end
