class Lesson < ActiveRecord::Base
	include Dewey::Concerns::LessonConcern
	include Pulitzer::Concerns::URLConcern
	mounted_at '/lessons'

	def slug
		self.id
	end

end
