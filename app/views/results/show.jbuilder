json.metadata do
	json.total @results.total_count
	json.total_pages @results.total_pages
	json.current_page @results.current_page
end
json.results @results do |result|
	json.id result.id
	json.place_overall result.place_overall
	json.place_gender result.place_gender
	json.place_age_group result.place_age_group
	json.status result.status ? result.status.upcase : nil
	json.participant do
		json.id result.participant.id
		json.person result.participant.person.attributes
		json.bib_number result.participant.bib_number
		json.gender result.participant.gender
		json.age result.participant.age
		json.age_group result.participant.age_group.name
	end
	json.laps_total result.laps_total
	json.distance_total result.participant.event_detail.lap_distance ? (result.participant.event_detail.lap_distance * result.laps_total) : result.lap_distance_total
	json.distance_units result.participant.event_detail.distance_units
	json.time_total_seconds result.time_total
	json.lap_time_total_seconds result.lap_time_total
	json.pit_time_total_seconds result.pit_time_total
	json.lap_time_average_seconds result.lap_time_avg
	json.pit_time_average_seconds result.pit_time_avg
end
