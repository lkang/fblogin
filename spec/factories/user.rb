FactoryGirl.define do
  sequence :email do |n|
    rnd = rand(9).to_s
    "somebody#{n}#{rnd}@vvo.com"
  end

  factory :user do
    email { FactoryGirl.generate :email }
    first_name 'Tera'
    last_name 'Patrick'
    password 'valid_password'
    password_confirmation 'valid_password'
  end
end
