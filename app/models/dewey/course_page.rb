module Dewey
	class CoursePage < Pulitzer::Media
		include Dewey::Concerns::CoursePageConcern
		include Dewey::CoursePageSearchable if (Dewey::CoursePageSearchable rescue nil)

	end
end
