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

		def duration_humanize
			secs = (self.duration_interval || 0).to_f
			[[60, :seconds], [60, :minutes], [24, :hours], [7, :days], [1000, :weeks]].inject([]){ |s, (count, name)|
				if secs > 0
					secs, n = secs.divmod(count)
					s.unshift ActionController::Base.helpers.pluralize(n.to_i,name.to_s.singularize) if n.to_i > 0
				end
				s
			}.join(' ')
		end

		def duration_humanize=(val)
			seconds = 0.seconds
			parts = val.strip.gsub(/[\s]+/,' ').split(' ')
			parts.each_slice(2) do |value,unit|
				seconds = seconds + value.to_f.try(unit)
			end

			self.duration_interval = seconds

			seconds
		end

		def duration_interval=(interval)
			hours = interval.to_f / 3600;
			minutes = (interval.to_f % 3600) / 60;
			seconds = interval.to_f % 60;
			self.duration = "#{hours.to_i}:#{minutes.to_i}:#{seconds}";
		end

		def duration_interval
			return nil if self.duration.nil?
			parts = self.duration.split(':')
			parts.first.to_f.hours + parts.second.to_f.minutes + parts.third.to_f.seconds
		end

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
