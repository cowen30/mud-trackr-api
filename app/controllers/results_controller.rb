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

		filter_clause = Result.joins(:participant).where(participants: { event_detail: params[:event_detail_id] }) if params[:event_detail_id].present?
		if params[:search].present?
			search_term = params[:search]
			filter_clause =
				filter_clause.and(Result.where('people.name ILIKE ?', "%#{search_term}%")
				.or(Result.where('people.last_name ILIKE ?', "%#{search_term}%")
				.or(Result.where('people.first_name ILIKE ?', "%#{search_term}%")
				.or(Result.where('participant.bib_number ILIKE ?', "%#{search_term}%")))))
		end

		sort_field = SORT_FIELD_DEFAULT
		sort_direction = SORT_DIRECTION_DEFAULT
		if params[:sort].present?
			sort_field = determine_sort_field
			sort_direction = determine_sort_direction
		end

		order_clause = Result.order(sort_field => sort_direction)
			.order('lap_distance_total DESC')
			.order('lap_time_total ASC')
		pagination_clause = Result.page(params[:page]).per(params[:page_size])

		@result_details =
			Result
			.joins([participant: %i[person event_detail]])
			.left_outer_joins(:result_details)
			.group(:id)
			.select(
				'results.id',
				'sum(result_details.lap_distance) as lap_distance_total',
				'sum(result_details.lap_time) + sum(result_details.pit_time) as time_total',
				'sum(result_details.lap_time) as lap_time_total',
				'sum(result_details.pit_time) as pit_time_total',
				'avg(result_details.lap_time) as lap_time_avg',
				'avg(result_details.pit_time) as pit_time_avg',
				'count(result_details.*) as laps_total'
			)
			.merge(filter_clause)

		@results =
			Result
			.joins([participant: %i[person event_detail]])
			.joins("INNER JOIN (#{@result_details.to_sql}) aggregate ON results.id = aggregate.id")
			.includes(([participant: %i[person event_detail age_group]]))
			.select(
				'results.*',
				'aggregate.*'
			)
			.unscope(where: { participants: :event_detail })
			.where('participants_results.event_detail_id = ?', params[:event_detail_id])
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
