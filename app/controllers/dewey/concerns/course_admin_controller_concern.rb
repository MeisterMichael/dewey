module Dewey
	module Concerns

		module CourseAdminControllerConcern
			extend ActiveSupport::Concern

			included do
			end


			####################################################
			# Class Methods

			module ClassMethods



			end


			####################################################
			# Instance Methods


			def create
				@course = Course.new( course_params )
				@course.status = 'draft'
				@course.course_page = Dewey::CoursePage.new( user: current_user, title: "Course Home" )
				@course.completed_course_page = Dewey::CoursePage.new( user: current_user, status: 'draft', title: "Course Complete" )

				authorize( @course )

				if @course.save
					set_flash 'Course Created'
					redirect_to dewey.edit_course_admin_path( @course )
				else
					set_flash 'Course could not be created', :error, @course
					redirect_back( fallback_location: '/admin' )
				end
			end


			def destroy
				authorize( @course )
				@course.trash!
				set_flash 'Course Deleted'
				redirect_back( fallback_location: '/admin' )
			end


			def edit
				authorize( @course )
				@course_cohorts = @course.course_cohorts.order(id: :desc).page(params[:page]).per(20)
			end


			def empty_trash
				authorize( Course )
				@courses = Course.trash.destroy_all
				redirect_back( fallback_location: '/admin' )
				set_flash "#{@courses.count} destroyed"
			end


			def index
				authorize( Course )
				sort_by = params[:sort_by] || 'publish_at'
				sort_dir = params[:sort_dir] || 'desc'

				@courses = Course.order( Arel.sql("#{sort_by} #{sort_dir}") )

				if params[:status].present? && params[:status] != 'all'
					@courses = eval "@courses.#{params[:status]}"
				end

				@courses = @courses.page( params[:page] )
			end


			def preview
				authorize( @course )
				@media = @course

				# copied from pulitzer_render
				set_page_meta( @media.page_meta )
				render @media.template, layout: @media.layout
			end


			def update

				@course.slug = nil if ( params[:course][:title] != @course.title ) || ( params[:course][:slug_pref].present? )

				@course.attributes = course_params

				authorize( @course )

				if @course.save
					set_flash 'Course Updated'
					redirect_to dewey.edit_course_admin_path( id: @course.id )
				else
					set_flash 'Course could not be Updated', :error, @course
					render :edit
				end

			end


			protected
				def course_params
					params.require( :course ).permit( :title, :description, :short_description, :introduction, :content, :syllabus, :slug_pref, :publish_at, :max_cohort_size, :status, :availability, :course_type, :course_content_schedule, :course_content_flow, :start_schedule, :instructor_id, :duration_humanize, :avatar_attachment, :cover_attachment, { embedded_attachments: [], other_attachments: [] } )
				end

				def get_course
					@course = Course.friendly.find( params[:id] )
				end


		end

	end
end
