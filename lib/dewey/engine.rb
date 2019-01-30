
# required gems from gemspec
require 'acts-as-taggable-array-on'
require 'devise'
require 'friendly_id'

module Dewey

	class << self

		# engine configuration settings accessors

		# settings defaults

	end

	# this function maps the vars from your app into the engine
     def self.configure( &block )
        yield self
     end


	class Engine < ::Rails::Engine
		isolate_namespace Dewey
	end
end
