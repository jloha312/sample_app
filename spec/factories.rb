#By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
	user.name					          "John Lohavichan"
	user.username               "johnlohavichan"
	user.permalink              "johnlohavichan"
	user.email					        "lohavichan@aol.com"
	user.password				        "foobar"
	user.password_confirmation	"foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :username do |n|
  "person-#{n}"
end

Factory.define :poll do |poll|
  poll.overall_grade "weak"
  poll.personalization "weak"
  poll.relevance "weak"
  poll.value_proposition "weak"
  poll.design "weak"
  poll.other "Spam"
  poll.responder_name "Joe Weak"
  poll.responder_email "joe@gmail.com"
  poll.comments "You are wasting my time, go and do your homework!"
  poll.next_steps "don't contact again"
  poll.association :user
end
