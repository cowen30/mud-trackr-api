Rails.application.routes.draw do
	# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

	resources :events
	resources :event_details, path: '/event-details'
	resources :results

end
