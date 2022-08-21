module ActiveSupportHelper

	def self.duration_to_string(duration)
		seconds = duration % 60
		minutes = (duration / 60) % 60
		hours = duration / (60 * 60)

		format('%<hours>02d:%<minutes>02d:%<seconds>02d', hours:, minutes:, seconds:)
	end

end
