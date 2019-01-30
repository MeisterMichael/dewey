module Dewey
	class EnrollmentLesson < ApplicationRecord
		belongs_to :lesson, class_name: 'Lesson'
		belongs_to :enrollment
		belongs_to :user, through: :enrollment
		belongs_to :course_cohort, through: :enrollment
		belongs_to :course, through: :course_cohort


		def course_cohort
			self.enrollment.course_cohort
		end

		def course
			self.course_cohort.course
		end

		def user
			self.enrollment.user
		end
		
	end

end
