class CreateParticipants < ActiveRecord::Migration[7.0]

	def change
		create_table :participants do |t|
			t.belongs_to :person, foreign_key: { to_table: :people }
			t.belongs_to :event_detail, foreign_key: true
			t.string :bib_number
			t.string :gender
			t.integer :age
			t.belongs_to :age_group, foreign_key: true
			t.string :participation_day
			t.integer :additional_laps
		end
	end

end
