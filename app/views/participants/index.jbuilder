json.metadata do
	json.total @participants.total_count
	json.total_pages @participants.total_pages
	json.current_page @participants.current_page
end
json.participants @participants do |participant|
	json.id participant.id
	json.person do
		json.id participant.person.id
		json.name participant.person.name
		json.first_name participant.person.first_name
		json.last_name participant.person.last_name
	end
	json.bib_number participant.bib_number
	json.gender participant.gender
	json.age participant.age
	json.age_group participant.age_group.name
end
