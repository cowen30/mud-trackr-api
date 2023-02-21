class ResultDetail::ResultDetailWriter

	def initialize(result_id:, lap_number:, lap_time:, pit_time:)
		@result_id = result_id
		@lap_number = lap_number
		@lap_time = lap_time
		@pit_time = pit_time
	end

	def create_result_detail
		begin
			ResultDetail.create!(
				result_id: @result_id,
				lap_number: @lap_number,
				lap_time: @lap_time,
				pit_time: @pit_time
			)
		rescue ActiveRecord::RecordNotUnique => e
		rescue ActiveRecord::RecordInvalid => e
			puts e.inspect
			# handle duplicate entry
		end
	end

end
