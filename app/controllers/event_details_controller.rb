# frozen_string_literal: true

class EventDetailsController < ActionController::API

	def index
		params.deep_transform_keys!(&:underscore)
		@event_details = EventDetail.all
		@event_details = @event_details.where(event_id: params[:event_id]) if params[:event_id].present?
	end

end
