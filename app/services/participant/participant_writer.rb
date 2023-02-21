class Participant::ParticipantWriter

	def initialize(person_id:, event_detail_id:, bib_number:, gender:, age:, age_group_id:)
		@person_id = person_id
		@event_detail_id = event_detail_id
		@bib_number = bib_number
		@gender = gender
		@age = age
		@age_group_id = age_group_id
	end

	def create_participant
		begin
			Participant.create!(
				person_id: @person_id,
				event_detail_id: @event_detail_id,
				bib_number: @bib_number,
				gender: @gender,
				age: @age,
				age_group_id: @age_group_id
			)
		rescue ActiveRecord::RecordNotUnique => e
			# handle duplicate entry
		end
	end

end
