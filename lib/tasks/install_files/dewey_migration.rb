class DeweyMigration < ActiveRecord::Migration[5.1]

	def change

		create_table :dewey_courses do |t|
			t.string			:title
			t.string			:avatar
			t.text				:description
			t.text				:syllabus
			t.string			:slug
			t.datetime		:publish_at, default: nil
			t.interval		:duration, default: nil
			t.integer			:max_cohort_size, default: nil
			t.integer 		:status, default: 0
			t.integer 		:availability, default: 1
			t.integer 		:course_type, default: 1
			t.integer 		:lesson_schedule, default: 1
			t.integer 		:start_schedule, default: 1
			t.references	:instructor, default: nil
			t.timestamps
		end

		create_table :dewey_course_cohorts do |t|
			t.references	:course
			t.datetime		:starts_at
			t.datetime		:ends_at, default: nil
			t.datetime		:enrollment_starts_at
			t.datetime		:enrollment_ends_at, default: nil
			t.references	:instructor, default: nil
			t.timestamps
		end

		create_table :dewey_enrollment_lessons do |t|
			t.references	:enrollment
			t.references	:lesson
			t.datetime		:started_at, default: nil
			t.datetime		:completed_at, default: nil
			t.float				:score, default: nil
			t.timestamps
		end

		create_table :dewey_enrollments do |t|
			t.references	:course_cohort
			t.references	:user
			t.datetime		:started_at
			t.datetime		:ends_at, default: nil
			t.datetime		:completed_at, default: nil
			t.float				:score, default: nil
			t.timestamps
		end

		create_table :lessons do |t|
			t.references	:course
			t.string			:title
			t.string			:avatar
			t.text				:description
			t.integer 		:seq, default: 0
			t.integer 		:status, default: 0
			t.interval		:duration, default: nil
			t.text				:overview
			t.text				:content
			t.timestamps
		end

	end
end
