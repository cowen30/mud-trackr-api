class CreateResults < ActiveRecord::Migration[7.0]

	def change
		create_table :results do |t|
			t.belongs_to :participant, foreign_key: true
			t.integer :place_overall
			t.integer :place_gender
			t.integer :place_age_group
			t.integer :status
		end
	end

end
