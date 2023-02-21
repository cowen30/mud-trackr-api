# frozen_string_literal: true

class ParticipantsController < ActionController::API

	PARAM_DEFAULTS = {
		page: 1,
		page_size: 25
	}.freeze

	def index
		params.deep_transform_keys!(&:underscore).reverse_merge!(PARAM_DEFAULTS)
		@participants = Participant.joins(:person).includes([:person, :age_group])
		@participants = @participants.where(event_detail_id: params[:event_detail_id])
		@participants = @participants.order('people.name ASC')
		@participants = @participants.page(params[:page]).per(params[:page_size])
	end

end
