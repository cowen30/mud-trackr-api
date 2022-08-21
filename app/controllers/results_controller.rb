class ResultsController < ActionController::API

	def index
		params.deep_transform_keys!(&:underscore)
		@results = Result.includes(%i[result_details]).joins([participant: [:person, { event_detail: :event }]]).where(participant: { event_details: { events: { archived: false } } })
		@results = @results.where(participant: { event_detail: params[:event_detail_id] }) if params[:event_detail_id].present?
		@results = @results.unscope(where: { events: :archived }) if params[:include_archived].present? && params[:include_archived] == 'true'
		render :show
	end

end
