module Dewey
	module Concerns

		module ApplicationControllerConcern
			extend ActiveSupport::Concern

			included do
				helper Dewey::ApplicationHelper
			end


			####################################################
			# Class Methods

			module ClassMethods

			end


			####################################################
			# Instance Methods


			protected

		end
	end
end
