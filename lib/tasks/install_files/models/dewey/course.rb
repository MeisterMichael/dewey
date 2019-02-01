module Dewey
	class Course < ApplicationRecord
		include Dewey::Concerns::CourseConcern
		include Dewey::CourseSearchable if (Dewey::CourseSearchable rescue nil)
		mounted_at '/edu/courses'

	end

end
