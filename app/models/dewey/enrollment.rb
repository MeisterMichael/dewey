module Dewey
	class Enrollment < ApplicationRecord
		belongs_to :user, class_name: 'User'
		belongs_to :course_cohort
		belongs_to :course, through: :course_cohort
	end

end
