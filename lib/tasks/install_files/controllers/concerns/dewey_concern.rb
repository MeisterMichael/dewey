
module DeweyConcern
	extend ActiveSupport::Concern

	included do
		helper_method :course_content_released?
	end


	####################################################
	# Class Methods

	module ClassMethods



	end


	####################################################
	# Instance Methods


	def course_content_released?( enrollment, course_content, options = {} )
		started_at = enrollment.started_at
		course = enrollment.course
		enrollment_course_contents = enrollment.enrollment_course_contents

		previous_course_contents = course.course_contents.where( seq: -Float::INFINITY..(course_content.seq-1) )
		previous_enrollment_course_contents = enrollment_course_contents.where( course_content: previous_course_contents ).where.not( completed_at: nil )
		time = options[:time] || Time.now

		# not released if scheduled start and it hasn't started yet
		return false if course.scheduled_start? && start_at > time

		# not released if sequential and all previous content hasn't been enrolled yet.
		return false if course.sequential_course_content? && previous_course_contents.count > 0 && previous_course_contents.count > previous_enrollment_course_contents.count

		# not released if time released, and content is released in the future
		return false if course.time_released_course_content? && ( started_at + course_content.release_offset_interval ) > time

		return true

	end

end
