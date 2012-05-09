# encoding: utf-8
class TeachersController < ApplicationController

  def index
    @teachers = User.teachers
    @indexes = TimetablesOnRails::FirstLetterIndex.build_from_name @teachers
  end

  def new
    @teacher = User.build_teacher
  end

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

  def show
    @teacher = User.teachers.find params[:id]
    @notifications = TimetablesOnRails::DateRegroup.group_by_day(Notification.related_to(@teacher).last_six_months.map {|n| NotificationPresenter.new n})
    @responsabilities = @teacher.responsabilities.map { |c| CoursePresenter.new c }
    @activities = @teacher.activities.map { |activity| ActivityItemPresenter.new activity }
  end

end
