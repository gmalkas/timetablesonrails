# encoding: utf-8

##
#
# = TeachersController
#
# Renders basic information about teachers and handles user creation.
#
class TeachersController < ApplicationController

  ##
  # 
  # Builds then renders an indexed list of teachers.
  #
  def index
    @teachers = User.teachers
    @indexes = TimetablesOnRails::FirstLetterIndex.build_from_name @teachers
  end

  ##
  # 
  # Renders a form to create a new teacher. This is used only by administrators
  # to create specific user accouts (mainly for temporary employees) that are
  # not in the LDAP.
  #
  # These accounts are used as placeholders when a course manager or the 
  # administrator needs to assign an activity to a temporary employee.
  #
  def new
    @teacher = User.build_teacher
  end

  ##
  #
  # Creates the user.
  #
  # == Note
  #
  # We need to specify a password (to satisfy validations)
  # even though the account will not be used to sign in to the application.
  #
  def create
    @teacher = User.new params[:user]
    @teacher.password = (@teacher.username.blank?) ? "password" : @teacher.username

    if @teacher.save
      flash[:success] = "L'enseignant #{@teacher.name} a été enregistré"
      redirect_to teachers_path
    else
      render 'new'
    end
  end

  ##
  #
  # Renders information and notifications related to a specific teacher.
  #
  # == Note
  #
  # Administrator cannot be seen through this action, even though they have IDs.
  #
  # == See also
  #
  # User.teachers
  #
  def show
    @teacher = User.teachers.find params[:id]
    @notifications = TimetablesOnRails::DateRegroup.group_by_day(Notification.related_to(@teacher).last_six_months.map {|n| NotificationPresenter.new n})
    @responsabilities = @teacher.responsabilities.map { |c| CoursePresenter.new c }
    @activities = @teacher.activities.map { |activity| ActivityItemPresenter.new activity }
  end

end
