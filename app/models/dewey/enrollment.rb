module Dewey
	class Enrollment < ApplicationRecord
		belongs_to :user, class_name: 'User'
		belongs_to :course_cohort
		has_many :enrollment_course_contents

		before_create :set_started_at

		def course
			self.course_cohort.course
		end

		protected
		def set_started_at
			self.started_at ||= Time.now if self.course.on_demand_start?
			self.started_at ||= self.course_cohort.start_at if self.course.scheduled_start?
		end
	end

end
