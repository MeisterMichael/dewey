module Dewey
	class Enrollment < ApplicationRecord
		belongs_to :user, class_name: 'User'
		belongs_to :course_cohort
		has_many :enrollment_lessons

		before_create :set_started_at

		def course
			self.course_cohort.course
		end

		def published_at_for( lesson, args = {} )
			date = self.started_at
			if self.course.time_released_lessons?
				date = date + self.course.lessons.active.where( seq: -Float::INFINITY..lesson.seq ).order( seq: :asc ).to_a.sum{ |lesson| lesson.duration || 0.seconds }
			end

			date
		end

		protected
		def set_started_at
			self.started_at ||= Time.now if self.course.on_demand_start?
			self.started_at ||= self.course_cohort.start_at if self.course.scheduled_start?
		end
	end

end
