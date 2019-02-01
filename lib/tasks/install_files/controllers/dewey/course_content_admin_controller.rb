module Dewey
	class CourseContentAdminController < ApplicationAdminController
			include Dewey::Concerns::CourseContentAdminControllerConcern
			include DeweyConcern
			before_action :get_course_content, only: [ :edit, :update ]

			def create
				@course_content = Dewey::CourseContent.new()
				@course_content.attributes = course_content_params
				@course_content.status = 'active' if @course_content.course.draft?

				authorize( @course_content )

				if @course_content.save
					set_flash 'Course Content Created'
					redirect_to Rails.application.routes.url_helpers.edit_course_content_admin_path( id: @course_content.id )
				else
					set_flash 'CourseContent could not be created', :error, @course_content
					render :new
				end

			end

			def edit
				authorize( @course_content )
			end

			def new
				@course_content = Dewey::CourseContent.new( course_id: params[:course_id] )
				@course_content.seq = (@course_content.course.course_contents.active.order(seq: :desc).limit(1).pluck(:seq).first || 0) + 1
				@course_content.status = 'active' if @course_content.course.draft?

				authorize( @course_content )
			end

			def update
				@course_content.attributes = course_content_params

				authorize( @course_content )

				if @course_content.save
					set_flash 'Course Content Updated'
					redirect_to Dewey::Engine.routes.url_helpers.edit_course_admin_path( id: @course_content.course.id )
				else
					set_flash 'Course Content could not be Updated', :error, @course_content
					render :edit
				end

			end


			protected
			def get_course_content
				@course_content = Dewey::CourseContent.find( params[:id] )
			end

			def course_content_params
				params.require(:course_content).permit( :course_id, :title, :avatar, :description, :seq, :status, :duration_humanize, :release_offset_humanize, :overview, :content )
			end

	end
end
