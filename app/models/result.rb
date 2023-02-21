class Result < ApplicationRecord

	enum :status, %i[finished dnf dns]

	belongs_to :participant


end
