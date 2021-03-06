module Dewey

	class CoursesController < ApplicationController
			include Dewey::Concerns::DeweyConcern

			def index
				@courses = Dewey::Course.published
				@courses = @courses.order( publish_at: :desc ).page(params[:page]).per(10)
				log_event( { name: 'pageview' } )
				set_page_meta( page_title: 'Courses' )
			end

			def show
				@course = Dewey::Course.published.friendly.find( params[:id] )
				@course_cohorts = @course.course_cohorts.open_for_enrollment.order( id: :desc )
				@enrollment = current_user.enrollments.where( course_cohort: Dewey::CourseCohort.where( course: @course ) ).last if current_user.present?

				authorize( @course )

				log_event( { name: 'pageview', on: @course } )

				set_page_meta( @course.page_meta )
				# render @course_content.template, layout: @course_content.layout
			end

			protected
			def authorize( course )

			end

	end
end
