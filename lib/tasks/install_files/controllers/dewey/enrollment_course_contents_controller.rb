module Dewey
	class EnrollmentCourseContentsController < ApplicationController
			# include Dewey::Concerns::EnrollmentCourseContentControllerConcern
			include DeweyConcern

			before_action :authenticate_user!

			def create
				@enrollment_course_content = Dewey::EnrollmentCourseContent.new( params.require(:enrollment_course_content).permit(:course_content_id,:enrollment_id) )

				if @enrollment_course_content.enrollment.try(:user) != current_user
					set_flash "Wrong user", :error
					redirect_back fallback_location: '/'
				elsif @enrollment_course_content.save
					redirect_to Rails.application.routes.url_helpers.dewey_enrollment_course_content_path( @enrollment_course_content )
				else
					set_flash "Unable to enroll course content", :error, @enrollment_course_content
					redirect_back fallback_location: '/'
				end

			end

			def show
				@enrollment_course_content = current_user.enrollment_course_contents.find params[:id]
				authorize( @enrollment_course_content )

				@enrollment_course_content.update( started_at: Time.now ) unless @enrollment_course_content.started_at.present?

				@course_content	= @enrollment_course_content.course_content
				@enrollment 		= @enrollment_course_content.enrollment
				@course					= @enrollment_course_content.course

				set_page_meta( @course_content.page_meta )
			end

			def complete
				@enrollment_course_content = current_user.enrollment_course_contents.find params[:id]
				authorize( @enrollment_course_content )

				@enrollment_course_content.update( completed_at: Time.now ) unless @enrollment_course_content.completed_at.present?

				redirect_to Rails.application.routes.url_helpers.dewey_enrollment_path( @enrollment_course_content.enrollment )
			end

			protected
			def authorize( enrollment_course_content )
			end

	end
end
