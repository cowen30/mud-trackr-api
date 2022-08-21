class CreateResultDetails < ActiveRecord::Migration[7.0]

	def change
		create_table :result_details do |t|
			t.belongs_to :result, foreign_key: true
			t.integer :lap_number
			t.interval :lap_time
			t.interval :pit_time
			t.decimal :lap_distance
			t.string :distance_units
		end
	end

end
