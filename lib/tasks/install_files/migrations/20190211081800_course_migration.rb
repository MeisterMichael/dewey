class CourseMigration < ActiveRecord::Migration[5.1]

	def change

		add_column :dewey_courses, :course_page_id, :integer
		add_index :dewey_courses, :course_page_id

	end
end
