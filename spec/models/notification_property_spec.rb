require_relative '../spec_helper_lite'
require_relative '../../app/models/notification_property'

describe NotificationProperty do

  subject { NotificationProperty.new }
  
  it "supports reading and writing a name" do
    subject.name = "manager"
    subject.name.should == "manager"
  end

  it "supports reading and writing a value" do
    subject.value = "5"
    subject.value.should == "5"
  end

  it "supports reading and writing a resource" do
    subject.resource = "user"
    subject.resource.should == "user"
  end

  it "supports reading and writing a notification reference" do
    subject.notification_id = 5
    subject.notification_id.should == 5
  end

  it "supports being initialized with attributes" do
    property = NotificationProperty.new name: "manager",
                                        value: "5", resource: "user"
    property.name.should == "manager"
    property.value.should == "5"
    property.resource.should == "user"
  end
end
