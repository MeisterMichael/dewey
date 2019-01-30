module Dewey
	class CourseAdminController < ApplicationAdminController
		before_action :get_course, except: [ :create, :empty_trash, :index ]

		def create
			@course = Course.new( course_params )
			@course.publish_at ||= Time.zone.now
			@course.user ||= current_user
			@course.status = 'draft'

			if params[:course][:category_name].present?
				@course.category = Category.where( name: params[:course][:category_name] ).first_or_create( status: 'active' )
			end

			authorize( @course )

			if @course.save
				set_flash 'Course Created'
				redirect_to edit_course_admin_path( @course )
			else
				set_flash 'Course could not be created', :error, @course
				redirect_back( fallback_location: '/admin' )
			end
		end


		def destroy
			authorize( @course )
			@course.trash!
			set_flash 'Course Deleted'
			redirect_back( fallback_location: '/admin' )
		end


		def edit
			authorize( @course )
			# create new working version if none exists or if not a draft
			# unless @course.working_media_version.try(:draft?)
			#
			# 	@course.update working_media_version: @course.media_versions.create
			#
			# end
			#
			# @current_draft = @course.working_media_version
		end


		def empty_trash
			authorize( Course )
			@courses = Course.trash.destroy_all
			redirect_back( fallback_location: '/admin' )
			set_flash "#{@courses.count} destroyed"
		end


		def index
			authorize( Course )
			sort_by = params[:sort_by] || 'publish_at'
			sort_dir = params[:sort_dir] || 'desc'

			@courses = Course.order( "#{sort_by} #{sort_dir}" )

			if params[:status].present? && params[:status] != 'all'
				@courses = eval "@courses.#{params[:status]}"
			end

			if params[:q].present?
				@courses = @courses.where( "array[:q] && keywords", q: params[:q].downcase )
			end

			@courses = @courses.page( params[:page] )
		end


		def preview
			authorize( @course )
			@media = @course

			# copied from pulitzer_render
			set_page_meta( @media.page_meta )
			render @media.template, layout: @media.layout
		end


		def update

			@course.slug = nil if ( params[:course][:title] != @course.title ) || ( params[:course][:slug_pref].present? )

			@course.attributes = course_params
			@course.avatar_urls = params[:course][:avatar_urls] if params[:course].present? && params[:course][:avatar_urls].present?


			if params[:course][:category_name].present?
				@course.category = Category.where( name: params[:course][:category_name] ).first_or_create( status: 'active' )
			end

			authorize( @course )

			if @course.save
				set_flash 'Course Updated'
				redirect_to edit_course_admin_path( id: @course.id )
			else
				set_flash 'Course could not be Updated', :error, @course
				render :edit
			end

		end


		private
			def course_params
				params.require( :course ).permit( :title, :subtitle, :avatar_caption, :slug_pref, :description, :content, :category_id, :status, :publish_at, :show_title, :is_commentable, :is_sticky, :user_id, :tags, :tags_csv, :redirect_url, :avatar_attachment, :cover_attachment, { embedded_attachments: [], other_attachments: [] } )
			end

			def get_course
				@course = Course.friendly.find( params[:id] )
			end


	end
end
