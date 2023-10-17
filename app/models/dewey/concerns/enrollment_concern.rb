module Dewey
	module Concerns

		module EnrollmentConcern
			extend ActiveSupport::Concern

			included do
				include Pulitzer::Concerns::UrlConcern

				belongs_to :user, class_name: 'User'
				belongs_to :course_cohort
				has_many :enrollment_course_contents

				before_create :set_started_at

			end


			####################################################
			# Class Methods

			module ClassMethods

			end


			####################################################
			# Instance Methods


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
end
