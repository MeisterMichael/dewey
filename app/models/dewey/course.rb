module Dewey
	class Course < ApplicationRecord
		include Pulitzer::Concerns::URLConcern
		#include Pulitzer::Concerns::ExpiresCache
		include Dewey::CourseSearchable if (Dewey::CourseSearchable rescue nil)

		mounted_at '/courses'

		belongs_to :instructor, class_name: 'User', optional: true

		has_many :course_cohorts
		has_many :enrollments, through: :course_cohorts
		has_many :users, through: :enrollments
		has_many :lessons, class_name: 'Lesson'

		enum status: { 'trash' => -100, 'not_available' => -50, 'wait_listed' => -1, 'draft' => 0, 'active' => 1 }
		enum course_type: { 'physical' => 1, 'digital' => 2 }
		enum lesson_schedule: { 'binged_lessons' => 1, 'time_released_lessons' => 2 }
		enum start_schedule: { 'on_demand_start' => 1, 'scheduled_start' => 2 }

		include FriendlyId
		friendly_id :slugger, use: [ :slugged, :history ]
		attr_accessor	:slug_pref

		has_one_attached :avatar_attachment
		has_one_attached :cover_attachment
		has_many_attached :embedded_attachments
		has_many_attached :other_attachments

		def slugger
			if self.slug_pref.present?
				self.slug = nil # friendly_id 5.0 only updates slug if slug field is nil
				return self.slug_pref
			else
				return self.title
			end
		end

	end

end
