module Dewey
	class Enrollment < ApplicationRecord
		include Dewey::Concerns::EnrollmentConcern
		include Dewey::EnrollmentSearchable if (Dewey::EnrollmentSearchable rescue nil)
		mounted_at Dewey.enrollments_path

	end

end
