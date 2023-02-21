class AgeGroup::AgeGroupReader

	def initialize
	end

	def get_age_group_by_name(event_detail_id, age_group_name)
		AgeGroup.find_by(event_detail_id: event_detail_id, name: age_group_name)
	end

end
