# frozen_string_literal: true

class ResultDetailsController < ActionController::API

	def index
		params.deep_transform_keys!(&:underscore)

		@result_details =
			ResultDetail
			.where(result_id: params[:result_id])
			.order(:id)

		default_lap_info = EventDetail.find(Result.joins(:participant).find(params[:result_id]).participant.event_detail_id)
		@default_lap_distance = default_lap_info.lap_distance
		@default_distance_units = default_lap_info.distance_units

		render :index
	end

end
