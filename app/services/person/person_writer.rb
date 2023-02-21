class Person::PersonWriter

	def initialize(name:, first_name: nil, last_name: nil)
		@name = name
		@first_name = first_name
		@last_name = last_name
	end

	def create_person
		begin
			Person.create!(
				name: @name,
				first_name: @first_name,
				last_name: @last_name
			)
		rescue ActiveRecord::RecordNotUnique => e
			# handle duplicate entry
		end
	end

end
