class EventDetail < ApplicationRecord

	belongs_to :event
	belongs_to :event_type

end
