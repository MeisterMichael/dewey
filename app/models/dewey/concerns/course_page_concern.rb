module Dewey
	module Concerns

		module CoursePageConcern
			extend ActiveSupport::Concern

			included do
				after_create :add_content_section
				before_create :set_default_values

				has_one :course
			end


			####################################################
			# Class Methods

			module ClassMethods

			end


			####################################################
			# Instance Methods

			def add_content_section
				section = self.content_sections.create( name: "#{self.title}-main")
			end

			def course
				if self.parent_id.nil?
					super() || Dewey::Course.find_by( completed_course_page: self )
				else
					root.course
				end
			end

			def page_meta
				super.merge( fb_type: 'article' )
			end

			def set_default_values
				self.availability = 'authorized_users'
				self.publish_at ||= Time.zone.now
				self.status = 'draft' if course.present? && course.active?
			end


		end

	end
end
