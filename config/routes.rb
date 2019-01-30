Dewey::Engine.routes.draw do

	resources :course_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection
	end

	resources :course_cohort_admin

end
