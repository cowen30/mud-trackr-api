# frozen_string_literal: true

class ResultsController < ActionController::API

	SORT_FIELD_DEFAULT = :place_overall
	SORT_FIELD_OPTIONS = {
		place_overall: :place_overall,
		place_gender: :place_gender,
		last_name: { person: :last_name },
		first_name: { person: :first_name },
		bib_number: { participant: :bib_number },
		age: { participant: :age }
	}.freeze
	SORT_DIRECTION_DEFAULT = :asc
	SORT_DIRECTION_OPTIONS = %i[asc desc].freeze

	def index
		params.deep_transform_keys!(&:underscore)
		@results = Result.includes(%i[result_details]).joins([participant: [:person, { event_detail: :event }]]).where(participant: { event_details: { events: { archived: false } } })
		@results = @results.where(participant: { event_detail: params[:event_detail_id] }) if params[:event_detail_id].present?
		@results = @results.unscope(where: { events: :archived }) if params[:include_archived].present? && params[:include_archived] == 'true'
		sort_field = SORT_FIELD_DEFAULT
		sort_direction = SORT_DIRECTION_DEFAULT
		if params[:sort].present?
			sort_field = determine_sort_field
			sort_direction = determine_sort_direction
		end
		@results = @results.order(sort_field => sort_direction)
		render :show
	end

	def stats
		params.deep_transform_keys!(&:underscore)
		@results = Result.joins(participant: [:age_group, { event_detail: :event }])
		@results = @results.where(participant: { event_detail: params[:event_detail_id] })
		render :stats
	end

	private

	def determine_sort_field
		sort_field = SORT_FIELD_DEFAULT
		sort_field = params[:sort].underscore.to_sym if params[:sort].present? && SORT_FIELD_OPTIONS.include?(params[:sort].underscore.to_sym)
		sort_field
	end

	def determine_sort_direction
		sort_direction = SORT_DIRECTION_DEFAULT
		sort_direction = params[:sort_direction].to_sym if params[:sort_direction].present? && SORT_DIRECTION_OPTIONS.include?(params[:sort_direction].to_sym)
		sort_direction
	end

end
