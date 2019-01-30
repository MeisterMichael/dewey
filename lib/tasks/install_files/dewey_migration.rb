class DeweyBaseMigration < ActiveRecord::Migration[5.1]

	def change

		create_table :dewey_courses do |t|
			t.string			:title
			t.string			:avatar
			t.text				:description
			t.text				:syllabus
			t.string			:slug
			t.datetime		:publish_at, default: nil
			t.integer			:max_cohort_size
			t.integer 		:status, default: 0
			t.integer 		:course_type, default: 1
			t.integer 		:lesson_schedule, default: 1
			t.integer 		:start_schedule, default: 1
			t.references	:instructor, default: nil
			t.timestamps
		end

		create_table :dewey_course_cohort do |t|
			t.references	:course
			t.datetime		:start_at
			t.datetime		:end_at, default: nil
			t.references	:instructor, default: nil
			t.timestamps
		end

		create_table :dewey_enrollment_lessons do |t|
			t.references	:enrollment
			t.references	:lesson
			t.datetime		:started_at, default: nil
			t.datetime		:completed_at, default: nil
			t.timestamps
		end

		create_table :dewey_enrollments do |t|
			t.references	:course_cohort
			t.references	:user
			t.datetime		:start_at
			t.datetime		:completed_at, default: nil
			t.float				:score, default: nil
			t.timestamps
		end

	end
end
