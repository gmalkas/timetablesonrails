require_relative '../spec_helper_lite'
require_relative '../../app/models/user'
require_relative '../../app/models/course'
require_relative '../../app/models/school_year_manager'
require_relative '../../app/models/notification'
require_relative '../../app/models/notification_property'
require_relative '../../app/models/notifications/new_course_candidate'

describe Notification do

  let(:gabriel) {
    FactoryGirl.create :user
  }

  let(:marin) {
    FactoryGirl.create :user, username: "mbertier"
  }

  let(:school_year) {
    SchoolYearManager.instance.new_school_year(SchoolYearManager.instance.build_school_year 2011)
  }

  let(:old_school_year) {
    SchoolYearManager.instance.new_school_year(SchoolYearManager.instance.build_school_year 2010)
  }

  let(:ruby) {
    school_year.semesters.first.new_course "Ruby"
  }

  let(:php) {
    school_year.semesters.first.new_course "PHP"
  }

  subject { Notification.notify_new_course_candidate school_year, gabriel, ruby }

  describe "#properties" do
    it "destroys properties when destroyed" do
      lambda { subject.destroy }.should change(subject.properties, :count).from(3).to(0)
    end
  end

  describe ".for_user" do

    let(:notification_two) { 
      Notification.notify_new_course_candidate school_year, gabriel, php
    }

    before do
      # TODO: Ugly, find a way to remove those lines
      subject
      notification_two
      #
      Notification.notify_new_course_candidate school_year, marin, ruby
    end

    it "only returns notifications that involves the user" do
      Set.new(Notification.related_to_user(gabriel)).should == Set.new([subject, notification_two])
    end

    it "orders the result by creation date, from the most recent to the oldest" do
      Notification.related_to_user(gabriel).should == [notification_two, subject]
    end

    context "when there are many shool years" do
      let(:old_notification) {
        Notification.notify_new_course_candidate old_school_year, gabriel, ruby
      }

      before do
        old_notification
      end

      it "only returns notifications related to the given school year" do
        Notification.occured_in(old_school_year).should == [old_notification] 
      end
    end
  end
end
