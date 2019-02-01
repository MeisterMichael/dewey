module Dewey
	class CourseContent < ActiveRecord::Base
		include Dewey::Concerns::CourseContentConcern
		include Pulitzer::Concerns::URLConcern
		mounted_at '/course_contents'
		self.table_name = 'dewey_course_contents'

		def slug
			self.id
		end

	end
end
