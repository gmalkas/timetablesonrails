require_relative '../../spec_helper_lite'

require_relative '../../../app/models/user'
require_relative '../../../app/models/notification'
require_relative '../../../app/models/notification_property'
require_relative '../../../app/models/notifications/new_course_candidate'
require_relative '../../../app/models/school_year_manager'

describe Notification do

  describe ".notify_new_course_candidate" do

    let(:teacher) {
      user = User.new firstname: "Gabriel", lastname: "Malkas", username: "gmalkas"
      user.password = "gabriel"
      user.save!
      user
    }

    let(:course) {
      school_year = SchoolYearManager.instance.new_school_year(SchoolYearManager.instance.build_school_year 2011)
      school_year.semesters.first.new_course "Ruby"
    }

    subject { Notification.notify_new_course_candidate teacher, course }

    it "can create a new course candidate notification" do
      course.stub(:candidates) { [teacher] }
      subject.type.should == "Notifications::NewCourseCandidate"
      subject.candidates.should == 1
      subject.teacher.should == teacher
      subject.course.should == course
    end

    context "when there is more than one candidate" do
      before do
        course.stub(:candidates) { [1, 2, 3] }
      end

      it "sets the style to error" do
        subject.style.should == "error" 
      end
    end

    context  "when there is only one candidate" do
      before do
        course.stub(:candidates) { [teacher] }
      end

      it "sets the style to success" do
        subject.style.should == "success"
      end
    end
  end

end
  
