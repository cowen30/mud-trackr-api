class CreateEvents < ActiveRecord::Migration[7.0]

	def change
		create_table :events do |t|
			t.string :name
			t.string :address
			t.string :locality
			t.string :region
			t.string :postal_code
			t.string :country
			t.date :date
			t.string :latitude
			t.string :longitude
			t.boolean :archived
		end
	end

end
