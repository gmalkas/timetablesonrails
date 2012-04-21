require_relative '../../spec_helper_lite'

require_relative '../../../app/models/user'
require_relative '../../../app/models/notification'
require_relative '../../../app/models/notification_property'
require_relative '../../../app/models/notifications/new_course_candidate'
require_relative '../../../app/models/school_year_manager'

require 'ostruct'

describe Notification do

  describe ".notify_new_course_candidate" do

    let(:teacher) {
      user = User.new firstname: "Gabriel", lastname: "Malkas", username: "gmalkas"
      user.password = "gabriel"
      user.save!
      user
    }

    let(:school_year) {
      SchoolYearManager.instance.new_school_year(SchoolYearManager.instance.build_school_year 2011)
    }

    let(:course) {
      school_year.semesters.first.new_course "Ruby"
    }

    subject { Notification.notify_new_course_candidate school_year, teacher, course }

    it "can create a new course candidate notification" do
      course.stub(:candidates) { [teacher] }
      subject.type.should == "Notifications::NewCourseCandidate"
      subject.candidates.should == 1
      subject.teacher.should == teacher
      subject.course.should == course
    end

    it "sets the school year reference" do
      subject.school_year.should == school_year
    end

    context "when there is more than one candidate" do
      before do
        course.stub(:candidates) { [teacher, OpenStruct.new(id: 2), OpenStruct.new(id: 3)] }
      end

      it "creates properties for the other candidates" do
        subject.properties.select { |p| p.name =~ /candidate_/ }.size.should == 2
      end

      it "sets the style to error" do
        subject.style.should == "error" 
      end
    end

  end

end
  
