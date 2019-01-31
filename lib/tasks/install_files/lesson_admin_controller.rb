class LessonAdminController < ApplicationAdminController
		include Dewey::Concerns::LessonAdminControllerConcern
		include Dewey::Engine.routes.url_helpers
		before_action :get_lesson, only: [ :edit, :update ]

		def create
			@lesson = Lesson.new()
			@lesson.attributes = lesson_params

			authorize( @lesson )

			if @lesson.save
				set_flash 'Lesson Created'
				redirect_to edit_course_admin_path( id: @lesson.course.id )
			else
				set_flash 'Lesson could not be created', :error, @lesson
				render :new
			end

		end

		def edit
			authorize( @lesson )
		end

		def new
			@lesson = Lesson.new( course_id: params[:course_id] )
			@lesson.seq = (@lesson.course.lessons.active.order(seq: :desc).limit(1).pluck(:seq).first || 0) + 1
			authorize( @lesson )
		end

		def update
			@lesson.attributes = lesson_params

			authorize( @lesson )

			if @lesson.save
				set_flash 'Lesson Updated'
				redirect_to edit_course_admin_path( id: @lesson.course.id )
			else
				set_flash 'Lesson could not be Updated', :error, @lesson
				render :edit
			end

		end


		protected
		def get_lesson
			@lesson = Lesson.find( params[:id] )
		end

		def lesson_params
			params.require(:lesson).permit( :course_id, :title, :avatar, :description, :seq, :status, :duration_humanize, :overview, :content )
		end

end
