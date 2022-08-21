class CreateAgeGroups < ActiveRecord::Migration[7.0]

	def change
		create_table :age_groups do |t|
			t.references :event_detail, foreign_key: true
			t.string :name
			t.string :gender
			t.integer :min_age
			t.integer :max_age
		end
	end

end
