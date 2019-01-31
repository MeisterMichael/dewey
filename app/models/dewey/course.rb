module Dewey
	class Course < ApplicationRecord
		include Pulitzer::Concerns::URLConcern
		#include Pulitzer::Concerns::ExpiresCache
		include Dewey::CourseSearchable if (Dewey::CourseSearchable rescue nil)

		before_save :set_avatar

		mounted_at Dewey.courses_path

		belongs_to :instructor, class_name: 'User', optional: true

		has_many :course_cohorts
		has_many :enrollments, through: :course_cohorts
		has_many :users, through: :enrollments
		has_many :lessons, class_name: 'Lesson'

		enum status: { 'trash' => -100, 'not_available' => -50, 'wait_listed' => -1, 'draft' => 0, 'active' => 1 }
		enum availability: { 'anyone' => 1, 'enrolled' => 2, 'invite_only' => 3 }
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

		def page_meta
			if self.title.present?
				title = "#{self.title} | #{Pulitzer.app_name}"
			else
				title = Pulitzer.app_name
			end

			return {
				page_title: title,
				title: self.title,
				image: self.avatar,
				url: self.url,
				twitter_format: 'summary_large_image',
				type: 'article',
				og: {
					"article:published_time" => self.publish_at.try(:iso8601),
					"article:author" => self.instructor.to_s
				},
				data: {
					'url' => self.url,
					'name' => self.title,
					'datePublished' => self.publish_at.try(:iso8601),
					'author' => self.instructor.to_s,
					'image' => self.avatar
				}

			}
		end

		def self.published( args = {} )
			where( "dewey_courses.publish_at <= :now", now: Time.zone.now ).active
		end

		def published?
			active? && publish_at < Time.zone.now
		end

		def set_avatar
			self.avatar = self.avatar_attachment.service_url if self.avatar_attachment.attached?
			self.cover_image = self.cover_attachment.service_url if self.cover_attachment.attached?
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
