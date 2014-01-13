FactoryGirl.define do
  factory :user do
    name     "Lutz Biedinger"
    email    "lbiedigner@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
