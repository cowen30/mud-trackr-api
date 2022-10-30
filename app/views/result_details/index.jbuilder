json.array! @result_details do |details|
	json.id details.id
	json.lap_number details.lap_number
	json.lap_time_seconds details.lap_time
	json.pit_time_seconds details.pit_time
	json.lap_distance details.lap_distance ? details.lap_distance.to_f : @default_lap_distance.to_f
	json.distance_units details.distance_units || @default_distance_units
end
