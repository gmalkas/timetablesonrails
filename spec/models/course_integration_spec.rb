require_relative '../spec_helper_lite'
require_relative '../../app/models/course'
require_relative '../../app/models/semester'
require_relative '../../app/models/school_year'

describe Course do

  subject { Course.new }

  it "needs a name to be valid" do
    subject.valid?.should be_false
    subject.errors[:name].should_not be_empty
  end

  it "needs a semester reference to be valid" do
    subject.valid?.should be_false
    subject.errors[:semester_id].should_not be_empty
  end

  describe "#new_candidate" do
    it "adds the candidate to the list" do
      user = User.new
      subject.new_candidate user
      subject.candidates.last.should == user
    end

    it "raises an exception if the course is already assigned" do
      subject.manager = User.new
      lambda { subject.new_candidate User.new }.should raise_error Course::AlreadyAssignedException
    end
  end

  context "when it has candidates" do
    subject { FactoryGirl.create :course }

    let(:user) { 
      FactoryGirl.create :user
    }

    before do
      subject.new_candidate user
    end

    describe "#dismiss_candidate" do
      it "removes the candidate from the list" do
        subject.dismiss_candidate user
        subject.candidates.should_not include(user)
      end
    end

    describe "#assign!" do
      it "assigns the candidate as a manager" do
        subject.assign! user
        subject.manager.should == user
      end

      it "dismiss all the other candidates" do
        subject.assign! user
        subject.candidates.should be_empty
      end
    end

    describe "#dismiss_candidates" do
      it "removes all the candidates from the list" do
        subject.dismiss_candidates
        subject.candidates.should be_empty
      end
    end
  end
end
