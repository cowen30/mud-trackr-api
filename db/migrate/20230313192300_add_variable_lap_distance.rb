class AddVariableLapDistance < ActiveRecord::Migration[7.0]

	def change
		add_column :event_details, :variable_lap_distance, :boolean, null: false, default: false
	end

end
