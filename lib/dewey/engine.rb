
# required gems from gemspec
require 'acts-as-taggable-array-on'
require 'devise'
require 'friendly_id'

module Dewey

		# engine configuration settings accessors
		mattr_accessor :courses_path
		mattr_accessor :enrollments_path

		# settings defaults
		self.courses_path = '/courses'
		self.enrollments_path = '/myclasses'

	# this function maps the vars from your app into the engine
     def self.configure( &block )
        yield self
     end


	class Engine < ::Rails::Engine
		isolate_namespace Dewey
	end
end
