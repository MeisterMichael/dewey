class LessonsController < ApplicationController
	include Dewey::Concerns::LessonControllerConcern

	def show
		@lesson = Lesson.find( params[:id] )

		authorize( @lesson )

		set_page_meta( @lesson.page_meta )
		# render @lesson.template, layout: @lesson.layout
	end

	protected
	def authorize( lesson )

	end

end
