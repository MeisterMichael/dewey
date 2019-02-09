module Dewey
	class CourseAdminController < ApplicationAdminController
		include Dewey::Concerns::DeweyConcern
		include Dewey::Concerns::CourseAdminControllerConcern
		before_action :get_course, except: [ :create, :empty_trash, :index ]

	end
end
