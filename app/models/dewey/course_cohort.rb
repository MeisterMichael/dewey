module Dewey
	class CourseCohort < ApplicationRecord

		belongs_to :instructor, class_name: 'User', optional: true
		belongs_to :course
		has_many :enrollments

		def self.open_ended_enrollment
			where( enrollment_ends_at: nil )
		end

		def open_ended_enrollment?
			self.enrollment_ends_at.blank?
		end

	end

end
