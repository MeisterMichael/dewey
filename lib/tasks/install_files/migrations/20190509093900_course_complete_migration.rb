class CourseCompleteMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :dewey_courses, :completed_course_page_id, :integer
		add_index :dewey_courses, :completed_course_page_id

	end
end
