module Dewey
	class EnrollmentCourseContent < ApplicationRecord
		belongs_to :course_content, class_name: 'Dewey::CourseContent'
		belongs_to :enrollment


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
