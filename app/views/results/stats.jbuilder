json.gender do
	json.male @results.where(participant: { gender: 'M' }).count
	json.female @results.where(participant: { gender: 'F' }).count
	json.other @results.where.not(participant: { gender: ['M', 'F'] }).count
end
json.age_group @results.group('age_groups.name').count do |age_group, count|
	json.name age_group
	json.count count
end
