module Dewey
	class EnrollmentLesson < ApplicationRecord
		belongs_to :lesson, class_name: 'Lesson'
		belongs_to :enrollment


		def course_cohort
			self.enrollment.course_cohort
		end

		def course
			self.course_cohort.course
		end

		def self.published( args = {} )
			where( "dewey_courses.published_at <= :now", now: Time.zone.now )
		end

		def published?
			published_at < Time.zone.now
		end

		def user
			self.enrollment.user
		end

	end

end
