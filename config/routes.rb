Rails.application.routes.draw do
	# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

	# Defines the root path route ("/")
	# root "articles#index"
	resources :results
	# resources :events, only: [:index, :show] do
	# 	resources :results
	# end
end
