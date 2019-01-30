class LessonController < ApplicationController
		def show
			authorize( @lesson )

			set_page_meta( @lesson.page_meta )

			render @lesson.template, layout: @lesson.layout
		end

end
