# encoding: utf-8
require_relative '../models/notifications/new_course_candidate'

##
# = CoursesController
#
# Handles CRUC functions and specific operations for courses, such as choosing
# a manager and dismissing candidates.
#
class CoursesController < ApplicationController

  before_filter :load_school_year

  authorize_resource

  def index
    @course = Course.new

    params[:filter] ||= Course::DefaultFilter[:filter]

    courses = @semesters.map(&:courses).flatten

    # TODO: This 'switch' should not be in a controller.
    courses = case params[:filter]
    when 'manager'
      TimetablesOnRails::CourseFilter.by_manager courses
    when 'status'
      TimetablesOnRails::CourseFilter.by_status courses
    end

    @course_list = CourseListPresenter.new @semesters, courses, params[:filter]
  end

  def edit
    @course = Course.find_by_id params[:id]
  end

  def update
    @course = Course.find_by_id params[:id]

		if @course.update_attributes(params[:course]) 
			flash[:success] = "Les modifications ont été enregistrées."
			redirect_to school_year_course_path(@school_year, @course)
		else 
			render :edit
		end
  end
  
  ##
  #
  # Shows the course and its related activities.
  #
  def show
    @course = Course.find_by_id params[:id]
    @activities = @course.activities.map { |activity| ActivityItemPresenter.new activity }
    @notifications = TimetablesOnRails::DateRegroup.group_by_day(Notification.related_to(@course).map {|n| NotificationPresenter.new n})
  end
  
  ##
  #
  # Adds the current user to the candidates list.
  #
  def apply
    course = Course.find_by_id params[:id]

    unless current_user.applied? course
      current_user.apply_to_course_management course
      Notification.notify_new_course_candidate @school_year, current_user, course

      flash[:success] = "Votre candidature à la gestion de l'E.C #{course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous avez déjà postulé à la gestion de l'E.C #{course.name}."
    end
  end

  ##
  #
  # Removes the current user from the candidates list.
  #
  def withdraw
    course = Course.find_by_id params[:id]
    
    if current_user.applied? course
      current_user.withdraw_course_management_application course
      Notification.notify_withdraw_course_management_application  @school_year, current_user, course

      flash[:success] = "Votre candidature à la gestion de l'E.C #{course.name} a été retirée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'avez pas postulé à la gestion de l'E.C #{course.name}."
    end
  end

  ##
  #
  # Given that the current user is the course's manager,
  # this action removes the "manager" association.
  # The current user effectively resigns as this course's manager.
  #  
  def resign
    course = Course.find_by_id params[:id]
    
    if current_user.manage? course
      current_user.resign_as_manager course
      Notification.notify_course_manager_resigned  @school_year, current_user, course

      flash[:success] = "Votre démission du poste de responsable de l'E.C #{course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'êtes pas responsable de l'E.C #{course.name}."
    end
  end

  ##
  #
  # Creates a course for a specific semester.
  # This action requires administrative privileges.
  #
  def create
    @course = @school_year.find_semester(params[:semester_id]).new_course(params[:course][:name])

    if @course.save
      flash[:success] = "#{@course.name} a été ajouté avec succès au semestre #{@course.semester.name}."
      redirect_to :back
    else
      render 'index'
    end
  end

  ##
  #
  # Shows a list of teachers to choose from in order to assign the course to one of them.
  # This action requires administrative privileges.
  #
  def pick_manager
    @course = Course.find_by_id params[:id]
    @teachers = User.teachers
    @indexes = TimetablesOnRails::FirstLetterIndex.build_from_name @teachers
  end

  ##
  #
  # Assigns a teacher to a specific course.
  # This action requires administrative privileges.
  #
  def assign_course_manager
    course = Course.find_by_id params[:id]
    candidate = User.teachers.find params[:candidate]
    Notification.notify_course_manager_chosen @school_year, current_user, candidate, course
    course.assign! candidate
    course.save!

    flash[:success] = "#{candidate.name} est désormais responsable de l'E.C #{course.name}."
    redirect_to school_year_courses_path(@school_year)
  end

  ##
  #
  # Removes a candidate from the list.
  # This action requires administrative privileges.
  #
  def dismiss_candidate
    course = Course.find_by_id params[:id]
    candidate = course.candidates.find params[:candidate]
    course.dismiss_candidate candidate
    course.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature de l'E.C #{course.name}."
    redirect_to :back
  end

  ##
  #
  # Destroys the course.
  # This action requires administrative privileges.
  #
  def destroy
    course = Course.find_by_id params[:id]
    course.destroy
    flash[:success] = "L'élément constitutif #{course.name} a été supprimé avec succès."
    redirect_to :back
  end

  private

  ##
  #
  # This controller needs a school year to work properly.
  # This method is used as a before_filter to ensure that a 
  # school year is defined.
  #
  def load_school_year
    @school_year = SchoolYearManager.instance.find! params[:school_year_id]
    @semesters = @school_year.semesters
  end
end
