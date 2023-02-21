class ConquestEvents

	base_url = 'https://points-prod.sweatworks.net/api'

	def self.get_results(course_id)
		base_url = 'https://points-prod.sweatworks.net/api'

		ctx = OpenSSL::SSL::SSLContext.new
		ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE

		raw_results = HTTP.get("#{base_url}/courses/#{course_id}", ssl_context: ctx)
		response = JSON.parse(raw_results.body)
		response['results']
	end

	def self.parse_results(results)
		event_detail_id = 4
		results.each do |result_data|
			# puts result.inspect
			name = result_data['name']
			person = Person::PersonWriter.new(name: name).create_person

			bib_number = result_data['bib']
			gender = get_gender(result_data['gender'])
			age = result_data['age']
			age_group = determine_age_group_id(event_detail_id, result_data['division'])
			participant = Participant::ParticipantWriter.new(
				person_id: person.id,
				event_detail_id: event_detail_id,
				bib_number: bib_number,
				gender: gender,
				age: age,
				age_group_id: age_group
			).create_participant

			place_overall = result_data['overallRanking']
			place_gender = result_data['genderRanking']
			place_age_group = result_data['divisionRanking']
			result = Result::ResultWriter.new(
				participant_id: participant.id,
				place_overall: place_overall,
				place_gender: place_gender,
				place_age_group: place_age_group,
				status: nil
			).create_result

			parse_result_details(result, result_data['toughestLaps'])

			puts "Loaded #{person.name}"
		end

	end

	def self.parse_result_details(result, details)
		details.each_with_index do |detail, index|
			next if detail['lapDuration'].nil?
			lap_time = detail['lapDuration'] / 1000
			pit_time = nil
			if index < details.size - 1 && details[index + 1]['startTime'].present? && detail['startTime'].present?
				pit_time = (details[index + 1]['startTime'] - detail['startTime'] - detail['lapDuration']) / 1000
			end
			result_detail = ResultDetail::ResultDetailWriter.new(
				result_id: result.id,
				lap_number: index + 1,
				lap_time: lap_time,
				pit_time: pit_time
			).create_result_detail
		end
	end

	def self.get_gender(gender)
		gender == 'male' ? 'M' : 'F'
	end

	def self.determine_age_group_id(event_detail_id, age_group)
		nil if age_group.blank?
		age_group_name = age_group.gsub(/female /, 'F').gsub(/male /, 'M')
		age_group = AgeGroup::AgeGroupReader.new.get_age_group_by_name(event_detail_id, age_group_name)
		age_group.present? ? age_group.id : nil
	end

end
