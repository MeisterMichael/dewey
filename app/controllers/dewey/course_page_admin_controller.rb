module Dewey

	class CoursePageAdminController < AdminController
		before_action :get_page, except: [ :create, :index ]

		def create
			authorize( Dewey::CoursePage )
			@page = Dewey::CoursePage.new( page_params )
			@page.availability = 'authorized_users'
			@page.publish_at ||= Time.zone.now
			@page.user = current_user
			@page.parent_id = params[:page][:parent_id]
			@page.status = 'draft' if @page.parent.active?

			if @page.save
				set_flash 'Page Created'
				redirect_to edit_course_page_admin_path( @page )
			else
				set_flash 'Page could not be created', :error, @page
				redirect_back( fallback_location: '/admin' )
			end
		end

		def destroy
			authorize( @page )
			@page.trash!
			set_flash 'Page Trashed'
			redirect_back( fallback_location: '/admin' )
		end


		def edit
			authorize( @page )

			partial_path = "#{Rails.root}/app/views/pulitzer/content_sections/partials/"

			@partials = [ 'default', 'default_contained' ]
			@partials += Dir.glob( "#{partial_path}**/*" ).collect{ |f| f.gsub( '.html.haml', '' ).gsub( "#{partial_path}_", '' )  }
			@partials.sort!
		end



		def preview
			authorize( @page )
			@media = @page

			# copied from pulitzer_render
			set_page_meta( @media.page_meta )
			render @media.template, layout: @media.layout
		end


		def update
			authorize( @page )

			@page.slug = nil if params[:page][:slug_pref].present? || params[:page][:title] != @page.title
			@page.attributes = page_params

			if @page.save
				set_flash 'Page Updated'
				redirect_to edit_course_page_admin_path( id: @page.id )
			else
				set_flash 'Page could not be Updated', :error, @page
				render :edit
			end
		end

		private
			def page_params
				params.require( :page ).permit( :parent_id, :title, :subtitle, :avatar_caption, :slug_pref, :description, :content, :status, :availability, :publish_at, :show_title, :is_sticky, :is_commentable, :user_id, :tags, :tags_csv, :layout, :template, :avatar_attachment, :cover_attachment, { embedded_attachments: [], other_attachments: [] } )
			end

			def get_page
				@page = Dewey::CoursePage.friendly.find( params[:id] )
			end




	end


end
