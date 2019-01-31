# desc "Explaining what the task does"
namespace :dewey do
	task :install do
		puts "Installing Dewey. Who goes there?"

		files = {
			'course_controller.rb' => 'app/controllers',
			'lesson.rb' => 'app/models',
			'lesson_controller.rb' => 'app/controllers',
			'views/lesson_admin' => 'app/views',
			'views/lessons' => 'app/views',
			'views/courses' => 'app/views',
		}


		FileUtils::mkdir_p( File.join( Rails.root, 'app/roles' ) )

		files.each do |filename, path|
			puts "installing: #{path}/#{filename}"

			source = File.join( Gem.loaded_specs["dewey"].full_gem_path, "lib/tasks/install_files", filename )
    		if path == :root
    			target = File.join( Rails.root, filename )
    		else
    			target = File.join( Rails.root, path, filename )
    		end
    		FileUtils.cp_r source, target
		end

		dir = FileUtils::mkdir_p( File.join( Rails.root, 'app/views/devise/sessions/' ) )
		source = File.join( Gem.loaded_specs["dewey"].full_gem_path, "lib/tasks/install_files", 'sessions_new.html.haml' )
		target = File.join( Rails.root, 'app/views/devise/sessions/', 'new.html.haml' )
		FileUtils.cp_r source, target

		# migrations

		FileUtils::mkdir_p( File.join( Rails.root, 'db/migrate/' ) )


		migrations = [
			'dewey_migration.rb',
		]

		prefix = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i

		migrations.each do |filename|

			puts "installing: db/migrate/#{prefix}_#{filename}"

			source = File.join( Gem.loaded_specs["dewey"].full_gem_path, "lib/tasks/install_files", filename )

    		target = File.join( Rails.root, 'db/migrate', "#{prefix}_#{filename}" )

    		FileUtils.cp_r source, target
    		prefix += 1
		end

		puts "Add the following to your config/routes.rb"
		puts "resources :lesson_admin"
		puts "resources :lessons"

	end

end
