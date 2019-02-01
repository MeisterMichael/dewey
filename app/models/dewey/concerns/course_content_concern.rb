module Dewey
	module Concerns

		module CourseContentConcern
			extend ActiveSupport::Concern

			included do
				belongs_to :course, class_name: 'Dewey::Course'

				before_save :set_avatar

				enum status: { 'trash' => -100, 'draft' => 0, 'active' => 1 }

				has_one_attached :avatar_attachment
				has_one_attached :cover_attachment
				has_many_attached :embedded_attachments
				has_many_attached :other_attachments
			end


			####################################################
			# Class Methods

			module ClassMethods



			end


			####################################################
			# Instance Methods


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




			def release_offset_humanize
				secs = (self.release_offset_interval || 0).to_f
				[[60, :seconds], [60, :minutes], [24, :hours], [7, :days], [1000, :weeks]].inject([]){ |s, (count, name)|
					if secs > 0
						secs, n = secs.divmod(count)
						s.unshift ActionController::Base.helpers.pluralize(n.to_i,name.to_s.singularize) if n.to_i > 0
					end
					s
				}.join(' ')
			end

			def release_offset_humanize=(val)
				seconds = 0.seconds
				parts = val.strip.gsub(/[\s]+/,' ').split(' ')
				parts.each_slice(2) do |value,unit|
					seconds = seconds + value.to_f.try(unit)
				end

				self.release_offset_interval = seconds

				seconds
			end

			def release_offset_interval=(interval)
				hours = interval.to_f / 3600;
				minutes = (interval.to_f % 3600) / 60;
				seconds = interval.to_f % 60;
				self.duration = "#{hours.to_i}:#{minutes.to_i}:#{seconds}";
			end

			def release_offset_interval
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
					"article:author" => self.course.instructor.to_s
				},
				data: {
					'url' => self.url,
					'name' => self.title,
					'author' => self.course.instructor.to_s,
					'image' => self.avatar
				}

			}
			end

			def self.published( args = {} )
				where( "dewey_courses.publish_at <= :now", now: Time.zone.now ).active
			end

			def set_avatar
				self.avatar = self.avatar_attachment.service_url if self.avatar_attachment.attached?
				# self.cover_image = self.cover_attachment.service_url if self.cover_attachment.attached?
			end

			protected


		end

	end
end
