# frozen_string_literal: true

class ParticipantsController < ActionController::API

	def index
		params.deep_transform_keys!(&:underscore)
		@participants = Participant.joins(:person)
		@participants = @participants.where(event_detail_id: params[:event_detail_id])
		@participants = @participants.order(name: :asc)
	end

end
