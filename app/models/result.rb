class Result < ApplicationRecord

	enum :status, %i[finished dnf dns]

	belongs_to :participant

	has_one :result_details_stat

end
