require_relative '../spec_helper_lite'
require_relative '../../app/models/activity'

describe Activity do
  subject { Activity.new }

  it "supports reading and writing a type" do
    subject.type = "TP"
    subject.type.should == "TP"
  end

  it "supports reading and writing a duration" do
    subject.duration = 10 
    subject.duration.should == 10
  end

  it "supports reading and writing a groups number" do
    subject.groups = 2
    subject.groups.should == 2
  end
end
