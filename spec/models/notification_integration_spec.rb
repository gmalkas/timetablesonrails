require_relative '../spec_helper_lite'
require_relative '../../app/models/user'
require_relative '../../app/models/course'
require_relative '../../app/models/school_year_manager'
require_relative '../../app/models/notification'
require_relative '../../app/models/notification_property'
require_relative '../../app/models/notifications/new_course_candidate'

describe Notification do

  let(:gabriel) {
    user = User.new firstname: "Gabriel", lastname: "Malkas", username: "gmalkas"
    user.password = "gabriel"
    user.save!
    user
  }

  let(:marin) {
    user = User.new firstname: "Marin", lastname: "Bertier", username: "mbertier"
    user.password = "marin"
    user.save!
    user
  }

  let(:school_year) {
    SchoolYearManager.instance.new_school_year(SchoolYearManager.instance.build_school_year 2011)
  }

  let(:ruby) {
    school_year.semesters.first.new_course "Ruby"
  }

  let(:php) {
    school_year.semesters.first.new_course "PHP"
  }

  subject { Notification.notify_new_course_candidate gabriel, ruby }

  describe "#properties" do
    it "destroys properties when destroyed" do
      lambda { subject.destroy }.should change(subject.properties, :count).from(3).to(0)
    end
  end

  describe ".for_user" do

    let(:notification_two) { 
      Notification.notify_new_course_candidate gabriel, php
    }

    before do
      # TODO: Ugly, find a way to remove those lines
      subject
      notification_two
      #
      Notification.notify_new_course_candidate marin, ruby
    end

    it "only returns notifications that involves the user" do
      Set.new(Notification.for_user(gabriel)).should == Set.new([subject, notification_two])
    end

    it "orders the result by creation date, from the most recent to the oldest" do
      Notification.for_user(gabriel).should == [notification_two, subject]
    end
  end
end
