require 'spec_helper'
require 'session_helper'

describe CoursesController do

  # This controller is unavailable as guest, we need an active session
  before { stub_session controller }

  context "when there is an active school year" do

    let(:active_school_year) { FactoryGirl.create :school_year }

    before do
      SchoolYearManager.instance.stub(:active_school_year) { active_school_year }
    end

    describe "GET index" do
      it "fetches the semesters" do
        get :index
        assigns[:active_school_year].should_not be_nil
        assigns[:semesters].should_not be_nil
      end
    end

    describe "POST create" do

      # We need to be administrator to use this action
      before { stub_session controller, FactoryGirl.create(:administrator) }

      context "when the course is valid" do

        let(:params) { { semester_id: active_school_year.semesters.first.id, course: { name: "Ruby" } } }

        it "saves the course" do
          post :create, params
          # This is not the best way to test the fact that the course is saved
          # We might want to use a mock object and expect a #save! call
          # But that would be testing an implementation vs. testing a behaviour
          # I am still not sure which solution is better
          Course.all.first.name.should == "Ruby"
        end

        it "redirects to the index action" do
          post :create, params
          response.should redirect_to(active_school_year_path)
        end
      end

      context "when the course is not valid" do
        it "renders the index view" do
          post :create, semester_id: active_school_year.semesters.first.id, course: { name: "" }
          response.should render_template("index")
        end
      end

      context "when the semester does not exist" do
        it "renders a 404 error" do
          post :create, course: { name: "Ruby" }
          response.should render_template("errors/404")
        end
      end
    end
  end

  context "when there is no active school year" do
    it "redirects to root with an alert message" do
      get :index
      response.should redirect_to(root_path)
    end
  end
end
