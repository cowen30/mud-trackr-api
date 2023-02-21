class Result::ResultWriter

	def initialize(participant_id:, place_overall:, place_gender:, place_age_group:, status:)
		@participant_id = participant_id
		@place_overall = place_overall
		@place_gender = place_gender
		@place_age_group = place_age_group
		@status = status
	end

	def create_result
		begin
			Result.create!(
				participant_id: @participant_id,
				place_overall: @place_overall,
				place_gender: @place_gender,
				place_age_group: @place_age_group,
				status: @status
			)
		rescue ActiveRecord::RecordNotUnique => e
		rescue ActiveRecord::RecordInvalid => e
			puts e.inspect
			# handle duplicate entry
		end
	end

end
