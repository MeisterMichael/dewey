class CoursesController < ApplicationController
		include Dewey::Concerns::CourseControllerConcern

		def index
			@courses = Dewey::Course.published
			@courses = @courses.order( publish_at: :desc ).page(params[:page]).per(10)
			set_page_meta( page_title: 'Courses' )
		end

		def show
			@course = Dewey::Course.published.friendly.find( params[:id] )

			authorize( @course )

			set_page_meta( @course.page_meta )
			# render @lesson.template, layout: @lesson.layout
		end

		protected
		def authorize( course )

		end

end
