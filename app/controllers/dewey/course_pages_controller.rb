module Dewey

	class CoursePagesController < RootController
		include Dewey::Concerns::DeweyConcern

		def pulitzer_render(media)

			@course = media.root.course
			@enrollment = current_user.enrollments.find( params[:enrollment_id] ) if params[:enrollment_id]
			@previous_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( lft: @media.left ).where( lft: 0..@media.left ).order(lft: :desc)
			@next_course_pages = @course.course_page.descendants.publish_at_before_now.active.where.not( lft: @media.left ).where.not( lft: 0..@media.left ).order(lft: :asc)

			super(media)
		end

	end
end
