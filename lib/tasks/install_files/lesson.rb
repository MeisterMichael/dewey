class Lesson < ActiveRecord
	include Dewey::Concerns::LessonConcern
	include Pulitzer::Concerns::URLConcern
	mounted_at '/lessons'


end
