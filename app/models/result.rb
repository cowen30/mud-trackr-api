class Result < ApplicationRecord

	enum :status, %i[finished dnf dns]

	belongs_to :participant
	belongs_to :age_group

	has_many :result_details

end
