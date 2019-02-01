module Dewey
	class CourseCohortAdminController < ApplicationAdminController
		before_action :get_course_cohort, except: [ :create, :index ]

		def create
			@course_cohort = CourseCohort.new( course_cohort_params )

			authorize( @course_cohort )

			if @course_cohort.save
				set_flash 'Course Cohort Created'
				redirect_back( fallback_location: '/admin' )
			else
				set_flash 'Course Cohort could not be created', :error, @course_cohort
				redirect_back( fallback_location: '/admin' )
			end
		end


		def destroy
			authorize( @course_cohort )
			@course_cohort.trash!
			set_flash 'Course Cohort Deleted'
			redirect_back( fallback_location: '/admin' )
		end


		def edit
			authorize( @course_cohort )
		end


		def update

			@course_cohort.attributes = course_cohort_params

			authorize( @course_cohort )

			if @course_cohort.save
				set_flash 'Course Cohort Updated'
				redirect_to main_app.edit_dewey_course_admin_path( id: @course_cohort.course.id )
			else
				set_flash 'Course Cohort could not be Updated', :error, @course_cohort
				render :edit
			end

		end


		private
			def course_cohort_params
				params.require( :course_cohort ).permit( :instructor_id, :course_id, :starts_at, :ends_at, :enrollment_starts_at, :enrollment_ends_at,  )
			end

			def get_course_cohort
				@course_cohort = CourseCohort.find( params[:id] )
			end


	end
end
