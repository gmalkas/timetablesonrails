require_relative '../spec_helper_lite'
require_relative '../../app/models/notification'
require_relative '../../app/models/notification_property'

require 'ostruct'

describe Notification do
  subject { Notification.new }
  
  it "supports reading and writing a type" do
    subject.type = "NewCourseCandidate"
    subject.type.should == "NewCourseCandidate"
  end

  it "supports reading and writing a creation date" do
    now = Time.now
    subject.created_at = now
    subject.created_at.should == now
  end

  it "supports reading and writing a style" do
    subject.style = "success"
    subject.style.should == "success"
  end

  it "supports reading and writing a school year reference" do
    subject.school_year_id = 1
    subject.school_year_id.should == 1
  end

  it "starts with no properties" do
    subject.properties.should be_empty
  end

end
