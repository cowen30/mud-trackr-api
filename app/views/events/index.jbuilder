json.array! @events do |event|
	json.id event.id
	json.name event.name
	json.address event.address
	json.locality event.locality
	json.region event.region
	json.postal_code event.postal_code
	json.country event.country
	json.date event.date
end
