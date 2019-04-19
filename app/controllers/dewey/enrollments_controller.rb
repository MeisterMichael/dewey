module Dewey
	class EnrollmentsController < ApplicationController
			# include Dewey::Concerns::EnrollmentControllerConcern
			include Dewey::Concerns::DeweyConcern

			before_action :authenticate_user!, except: :new

			def create
				@enrollment = Dewey::Enrollment.new( user: current_user )
				@enrollment.attributes = params.require(:enrollment).permit( :course_cohort_id )

				authorize( @enrollment )

				if @enrollment.save
					log_event( { name: 'enrolled', category: 'dewey', on: @enrollment.course, content: "enrolled in #{@enrollment.course.title}." } )

					set_flash "Congratulations you are enrolled!", :success
					redirect_to enrollment_path( @enrollment )
				else
					set_flash "There was an error while attempting to enroll you.", :error, @enrollment
					redirect_back fallback_location: '/'
				end
			end

			def index
				@enrollments = current_user.enrollments.order( id: :desc )
				@enrollments = @enrollments.page( params[:page] ).per(20)

				log_event( { name: 'pageview' } )
				set_page_meta( title: 'Enrollments' )
			end

			def new
				@course = Dewey::Course.find( params[:course_id] )
				@course_cohort = @course.course_cohorts.open_for_enrollment.order( id: :desc ).first
				@enrollment = Dewey::Enrollment.new( user: current_user, course_cohort: @course_cohort )

				log_event( { name: 'pageview', on: @course } )

				set_page_meta( @course.page_meta )
			end

			def show
				@enrollment = current_user.enrollments.find( params[:id] )
				@course = @enrollment.course
				@previous_course_pages = Dewey::CoursePage.none
				@next_course_pages = @course.course_page.descendants.publish_at_before_now.active.order(lft: :asc)

				log_event( { name: 'pageview', on: @course } )

				set_page_meta( @course.page_meta )
			end

			protected
			def authorize( enrollment )
				enrollment.course.anyone?
			end

	end
end
