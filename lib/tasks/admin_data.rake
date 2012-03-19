namespace :db do
	desc "Create Admin Users"
	task :admin => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(:name => "John Lohavichan",
		                     :username => "jlohavichan",
					               :email => "jlohavichan@grademypitch.com",
					               :password => "prel88",
					               :password_confirmation => "prel88")
		admin.toggle!(:admin)

	end
end