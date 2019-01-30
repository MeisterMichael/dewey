class Lesson < Pulitzer::Media
	include Dewey::Concerns::LessonConcern

	def page_meta
		super()
	end

end
