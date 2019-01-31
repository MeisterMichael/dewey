class EnrollmentLessonsController < ApplicationController
		# include Dewey::Concerns::EnrollmentLessonControllerConcern
		before_action :authenticate_user!

		def show
			@enrollment_lesson = current_user.enrollment_lessons.find params[:id]
			authorize( @enrollment_lesson )

			@enrollment_lesson.update( started_at: Time.now ) unless @enrollment_lesson.started_at.present?

			@lesson			= @enrollment_lesson.lesson
			@enrollment = @enrollment_lesson.enrollment
			@course			= @enrollment_lesson.course

			@previous_lesson = @course.lessons.where( seq: -Float::INFINITY..@lesson.seq ).order(seq: :desc).first
			@previous_enrollment_lesson = @enrollment.enrollment_lessons.where( lesson: @previous_lesson ).first

			@next_lesson = @course.lessons.where( seq: @lesson.seq..Float::INFINITY ).order(seq: :asc).first
			@next_enrollment_lesson = @enrollment.enrollment_lessons.where( lesson: @previous_lesson ).first

			set_page_meta( @lesson.page_meta )
		end

		def complete
			@enrollment_lesson = current_user.enrollment_lessons.find params[:id]
			authorize( @enrollment_lesson )

			@enrollment_lesson.update( completed_at: Time.now ) unless @enrollment_lesson.completed_at.present?

			redirect_to enrollment_path( @enrollment_lesson.enrollment )
		end

		protected
		def authorize( enrollment_lesson )
		end

end
