# frozen_string_literal: true

class EventsController < ActionController::API

	def index
		params.deep_transform_keys!(&:underscore)
		@events = Event.where(archived: false).order(date: :desc)
	end

end
