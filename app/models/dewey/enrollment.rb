module Dewey
	class Enrollment < ApplicationRecord
		belongs_to :user, class_name: 'User'
		belongs_to :course_cohort

		def course
			self.course_cohort.course
		end
	end

end
