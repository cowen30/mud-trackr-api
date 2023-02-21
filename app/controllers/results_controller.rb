# frozen_string_literal: true

class ResultsController < ActionController::API

	PARAM_DEFAULTS = {
		page: 1,
		page_size: 25
	}.freeze

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

	# I feel like there's definitely a better way to do this, I just haven't figured it out yet
	def index
		params.deep_transform_keys!(&:underscore).reverse_merge!(PARAM_DEFAULTS)

		filter_clause = Result.joins(:participant)
		filter_clause = filter_clause.where(participants: { event_detail: params[:event_detail_id] }) if params[:event_detail_id].present?
		filter_clause = filter_clause.where('extract(year from event_details.start_date) = ?', params[:year]) if params[:year].present?
		filter_clause = filter_clause.where(participants: { event_detail: { events: { region: params[:region] } } }) if params[:region].present?
		filter_clause = filter_clause.where(participants: { event_detail: { events: { country: params[:country] } } }) if params[:country].present?
		if params[:search].present?
			search_term = params[:search]
			filter_clause =
				filter_clause.and(Result.where('people.name ILIKE ?', "%#{search_term}%")
				.or(Result.where('people.last_name ILIKE ?', "%#{search_term}%")
				.or(Result.where('people.first_name ILIKE ?', "%#{search_term}%")
				.or(Result.where('participants.bib_number ILIKE ?', "%#{search_term}%")))))
		end

		sort_field = SORT_FIELD_DEFAULT
		sort_direction = SORT_DIRECTION_DEFAULT
		if params[:sort].present?
			sort_field = determine_sort_field
			sort_direction = determine_sort_direction
		end

		order_clause = Result.order(sort_field => sort_direction)
			.order(Arel.sql('COALESCE(result_details_stats.lap_distance_total, result_details_stats.default_distance_total) DESC'))
			.order('result_details_stats.lap_time_total ASC')
		pagination_clause = Result.page(params[:page]).per(params[:page_size])

		@results =
			Result
			.joins([{ participant: [:person, event_detail: :event] }, :result_details_stat])
			.includes([{ participant: %i[person event_detail age_group] }, :result_details_stat])
			.merge(filter_clause)
			.merge(order_clause)
			.merge(pagination_clause)

		render :show
	end

	def stats
		params.deep_transform_keys!(&:underscore)
		@results = Result.joins(participant: [:age_group, { event_detail: :event }])
		@results = @results.where(participant: { event_detail: params[:event_detail_id] })
		render :stats
	end

	def load
		params.deep_transform_keys!(&:underscore)
		course_id = params[:course_id]
		results = ConquestEvents.get_results(course_id)
		ConquestEvents.parse_results(results)
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
