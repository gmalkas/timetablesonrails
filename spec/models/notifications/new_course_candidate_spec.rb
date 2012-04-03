require_relative '../../spec_helper_lite'
require_relative '../../../app/models/notification'
require_relative '../../../app/models/notification_property'
require_relative '../../../app/models/notifications/new_course_candidate'
require_relative '../../../app/models/user'
require_relative '../../../app/models/course'

require 'ostruct'

module Notifications
  describe NewCourseCandidate do
    subject { NewCourseCandidate.new }

    context "#properties" do

      let(:user) { OpenStruct.new id: 1 }
      let(:course) { OpenStruct.new id: 5 }

      before do
        subject.properties << NotificationProperty.new(name: 'teacher', type: 'user', value: 1)
        subject.properties << NotificationProperty.new(name: 'course', type: 'course', value: 5)
        subject.properties << NotificationProperty.new(name: 'candidates', type: "", value: 3)
      end

      it "returns the candidates number" do
        subject.candidates.should == 3
      end

      it "returns the teacher" do
        User.stub(:find_by_id) { user }

        subject.teacher.id.should == 1
      end

      it "returns the course" do
        Course.stub(:find_by_id) { course }

        subject.course.id.should == 5
      end
    end

  end
end
