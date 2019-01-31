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

		def self.open_for_enrollment

			# Enrollment has started
			course_cohorts = self.where( enrollment_starts_at: Time.at(0)..Time.now )

			# Not closed for enrollment
			course_cohorts = course_cohorts.open_ended_enrollment.or( course_cohorts.where( enrollment_ends_at: Time.now..100.years.from_now ) )
		end

		def open_for_enrollment?
			self.enrollment_starts_at <= Time.now && ( open_ended_enrollment? || self.enrollment_ends_at >= Time.now)
		end

	end

end
