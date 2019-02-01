class CourseContentAdminController < ApplicationAdminController
		include Dewey::Concerns::CourseContentAdminControllerConcern
		include DeweyConcern
		include Dewey::Engine.routes.url_helpers
		before_action :get_course_content, only: [ :edit, :update ]

		def create
			@course_content = CourseContent.new()
			@course_content.attributes = course_content_params

			authorize( @course_content )

			if @course_content.save
				set_flash 'CourseContent Created'
				redirect_to edit_course_admin_path( id: @course_content.course.id )
			else
				set_flash 'CourseContent could not be created', :error, @course_content
				render :new
			end

		end

		def edit
			authorize( @course_content )
		end

		def new
			@course_content = CourseContent.new( course_id: params[:course_id] )
			@course_content.seq = (@course_content.course.course_contents.active.order(seq: :desc).limit(1).pluck(:seq).first || 0) + 1
			authorize( @course_content )
		end

		def update
			@course_content.attributes = course_content_params

			authorize( @course_content )

			if @course_content.save
				set_flash 'CourseContent Updated'
				redirect_to edit_course_admin_path( id: @course_content.course.id )
			else
				set_flash 'CourseContent could not be Updated', :error, @course_content
				render :edit
			end

		end


		protected
		def get_course_content
			@course_content = CourseContent.find( params[:id] )
		end

		def course_content_params
			params.require(:course_content).permit( :course_id, :title, :avatar, :description, :seq, :status, :duration_humanize, :release_offset_humanize, :overview, :content )
		end

end
