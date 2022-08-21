class CreateEventDetails < ActiveRecord::Migration[7.0]

	def change
		create_table :event_details do |t|
			t.references :events, foreign_key: true
			t.references :event_types, foreign_key: true
			t.date :start_date
			t.date :end_date
			t.decimal :lap_distance
			t.string :distance_units
			t.decimal :lap_elevation
			t.string :elevation_units
		end
	end

end
