json.total @results.count
json.results @results do |result|
	json.id result.id
	json.place_overall result.place_overall
	json.place_gender result.place_gender
	json.place_age_group result.place_age_group
	json.status result.status.upcase
	json.participant do
		json.id result.participant.id
		json.person result.participant.person.attributes
		json.bib_number result.participant.bib_number
		json.gender result.participant.gender
		json.age result.participant.age
		json.age_group result.participant.age_group.name
	end
	json.laps_total result.result_details.count
	json.distance_total result.result_details.sum(:lap_distance)
	json.distance_units result.participant.event_detail.distance_units
	json.time_total_seconds result.result_details.sum(:lap_time) + result.result_details.sum(:pit_time)
	json.lap_time_total_seconds result.result_details.sum(:lap_time)
	json.pit_time_total_seconds result.result_details.sum(:pit_time)
	json.lap_time_average_seconds result.result_details.average(:lap_time)
	json.pit_time_average_seconds result.result_details.average(:pit_time)
	json.lap_details result.result_details do |details|
		json.id details.id
		json.lap_number details.lap_number
		json.lap_time_seconds details.lap_time
		json.pit_time_seconds details.pit_time
		json.lap_distance details.lap_distance
		json.distance_units details.distance_units
	end
end
