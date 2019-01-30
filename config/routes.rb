Dewey::Engine.routes.draw do

	resources :course_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection
	end

end
