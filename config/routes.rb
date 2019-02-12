Dewey::Engine.routes.draw do

	resources :course_page_admin do
		get :preview, on: :member
	end

	resources :course_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection
	end
	resources :course_cohort_admin
	resources :courses, path: Dewey.courses_path do
		resources :course_pages, path: 'pages'
	end
	resources :course_content_admin
	resources :enrollments, path: Dewey.enrollments_path do
		resources :course_pages, path: 'pages'
	end

end
