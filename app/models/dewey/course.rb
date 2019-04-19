module Dewey
	class Course < ApplicationRecord
		include Dewey::Concerns::CourseConcern
		include Dewey::CourseSearchable if (Dewey::CourseSearchable rescue nil)
		mounted_at Dewey.courses_path

		def to_s
			title
		end

	end

end
