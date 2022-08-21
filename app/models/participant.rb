class Participant < ApplicationRecord

	belongs_to :event_detail
	belongs_to :person
	belongs_to :age_group

end
