module Dewey
	class EnrollmentsController < ApplicationController
			# include Dewey::Concerns::EnrollmentControllerConcern
			include DeweyConcern

			before_action :authenticate_user!, except: :new

			def create
				@enrollment = Dewey::Enrollment.new( user: current_user )
				@enrollment.attributes = params.require(:enrollment).permit( :course_cohort_id )

				authorize( @enrollment )

				if @enrollment.save
					set_flash "Congratulations you are enrolled!", :success
					redirect_to Rails.application.routes.url_helpers.dewey_enrollment_path( @enrollment )
				else
					set_flash "There was an error while attempting to enroll you.", :error, @enrollment
					redirect_back fallback_location: '/'
				end
			end

			def index
				@enrollments = current_user.enrollments.order( id: :desc )
				@enrollments = @enrollments.page( params[:page] ).per(20)

				set_page_meta( title: 'Enrollments' )
			end

			def new
				@course = Dewey::Course.find( params[:course_id] )
				@course_cohort = @course.course_cohorts.open_for_enrollment.order( id: :desc ).first
				@enrollment = Dewey::Enrollment.new( user: current_user, course_cohort: @course_cohort )

				set_page_meta( @course.page_meta )
			end

			def show
				@enrollment = current_user.enrollments.find( params[:id] )
				@course = @enrollment.course

				set_page_meta( @course.page_meta )
			end

			protected
			def authorize( enrollment )
				enrollment.course.anyone?
			end

	end
end
