class CreatePeople < ActiveRecord::Migration[7.0]

	def change
		create_table :people do |t|
			t.string :name
			t.string :first_name
			t.string :last_name
		end
	end

end
