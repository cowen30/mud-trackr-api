class CreateEventTypes < ActiveRecord::Migration[7.0]

	def change
		create_table :event_types do |t|
			t.string :name
			t.string :short_name
			t.integer :display_order
		end
	end

end
