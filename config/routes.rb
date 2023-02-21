Rails.application.routes.draw do
	# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

	get '/health-check', to: proc { [200, {}, ['OK']] }

	resources :events
	resources :event_details, path: '/event-details'
	scope '/results' do
		get 'stats', to: 'results#stats'
		post 'load', to: 'results#load'
	end
	resources :results, only: :index do
		resources :result_details, path: '/details', only: :index
	end
	resources :participants, only: :index

end
