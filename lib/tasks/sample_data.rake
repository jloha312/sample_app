namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(:name => "Example User",
		                     :username => "exampleuser",
					               :email => "example@railstutorial.org",
					               :password => "foobar",
					               :password_confirmation => "foobar")
		admin.toggle!(:admin)
		
		99.times do |n|
			name  = Faker::Name.name
			username = "example-#{n+1}"
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(:name => name,
			       :username => username,
						 :email => email,
						 :password => password,
						 :password_confirmation => password)
		end
		
		50.times do |n|
		  overall_grade = "strong"
		  personalization = "strong"
		  relevance = "strong"
		  value_proposition = "weak"
		  design = "weak"
		  other = "compelling"
		  next_steps = "call me"
		  responder_name = Faker::Name.name
		  responder_email = "example-#{n+1}@railstutorial.org"
			
		  User.all(:limit => 6).each do |user|
		    user.polls.create!(:overall_grade => overall_grade,
		                  :personalization => personalization,
		                  :relevance => relevance,
		                  :value_proposition => value_proposition,
		                  :design => design,
		                  :other => other,
		                  :next_steps => next_steps,
		                  :responder_name => responder_name,
		                  :responder_email => responder_email,
		                  :comments => Faker::Lorem.sentence(5))
		  end
		end
	end
end