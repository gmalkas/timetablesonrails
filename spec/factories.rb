FactoryGirl.define do
  factory :school_year do
    start_date Date.new
    end_date { |s| s.start_date.next_year }
  end

  factory :semester do
    name "Semester 5"
    start_date Date.new
    end_date { |s| s.start_date.next_month }
    school_year
  end

  factory :course do
    name "Ruby"
    semester
  end

  factory :user, aliases: [:manager, :teacher] do
    firstname "Gabriel"
    lastname "Malkas"
    username "gmalkas"

    password "gabriel"
    password_confirmation { |u| u.password }

    factory :administrator do
      administrator true
    end
  end
end
