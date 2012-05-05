FactoryGirl.define do
  factory :user do
    firstname "Gabriel"
    lastname "Malkas"
    username "gmalkas"

    password "gabriel"
    password_confirmation { |u| u.password }
  end
end
