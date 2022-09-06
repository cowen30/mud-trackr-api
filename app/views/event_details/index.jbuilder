json.array! @event_details do |event_detail|
	json.id event_detail.id
	json.event do
		json.id event_detail.event.id
		json.name event_detail.event.name
	end
	json.event_type do
		json.id event_detail.event_type.id
		json.name event_detail.event_type.name
		json.short_name event_detail.event_type.short_name
	end
	json.start_date event_detail.start_date
	json.end_date event_detail.end_date
	json.lap_distance event_detail.lap_distance
	json.distance_units event_detail.distance_units
	json.lap_elevation event_detail.lap_elevation
	json.elevation_units event_detail.elevation_units
end
