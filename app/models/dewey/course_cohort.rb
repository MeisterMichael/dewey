module Dewey
	class CourseCohort < ApplicationRecord

		belongs_to :instructor, class_name: 'User', optional: true
		belongs_to :course
		has_many :enrollments

	end

end
