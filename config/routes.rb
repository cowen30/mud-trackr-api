Rails.application.routes.draw do
	# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

	get '/health-check', to: proc { [200, {}, ['OK']] }

	resources :events
	resources :event_details, path: '/event-details'
	scope '/results' do
		get 'stats', to: 'results#stats'
	end
	resources :results, only: :index

end
