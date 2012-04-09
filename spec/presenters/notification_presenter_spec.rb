require_relative '../spec_helper_lite'
require_relative '../../app/models/notification'
require_relative '../../app/models/notification_property'
require_relative '../../app/models/notifications/new_course_candidate'
require_relative '../../app/presenters/notification_presenter'

describe NotificationPresenter do

  let(:notification) { Notifications::NewCourseCandidate.new }
  subject { NotificationPresenter.new notification }

  it "supports being initialized with a notification" do
    subject.notification.should == notification
  end

  it "delegates calls to type to the notification" do
    notification.type = "new_course_candidate"
    subject.type.should == "new_course_candidate"
  end

  it "delegates calls to properties to the notification" do
    property = NotificationProperty.new
    notification.properties << property
    subject.properties.should include(property)
  end

  it "delegates calls to created_at to the notification" do
    now = Time.now
    notification.created_at = now
    subject.created_at.should == now
  end

  describe "#render" do
      let(:context) { mock }

    it "renders the proper partial according to the notification type" do
      context.should_receive(:render).with('notifications/new_course_candidate', {notification: subject.notification})
      subject.render(context)
    end
  end
end
