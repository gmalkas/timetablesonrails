# encoding: utf-8

##
#
# = ActivitiesController
#
# Handles CRUD functions and some operations specific to activities, such as
# choosing a teacher or dismissing a candidate.
#
class ActivitiesController < ApplicationController

  before_filter :load_school_year_and_course

  authorize_resource

  def new
    @activity = @course.activities.build
  end

  def create
    @activity = @course.new_activity params[:activity][:type], params[:activity][:groups], params[:activity][:duration]

    if @activity.save
      flash[:success] = "L'activité #{@activity.type} a été ajouté avec succès au cours #{@course.name}."
      redirect_to school_year_course_path(@school_year, @course)
    else
      render 'new'
    end
  end

  def edit
    @activity = @course.activities.find params[:id]
  end

  def update
    @activity = @course.activities.find params[:id]

		if @activity.update_attributes(params[:activity]) 
			flash[:success] = "Les modifications ont été enregistrées."
			redirect_to school_year_course_path(@school_year, @course)
		else 
			render :edit
		end
  end

  ##
  #
  # Shows a list of teachers to choose from in order to assign the activity to one of them.
  # This action requires either the user to be the course's manager or administrative privileges.
  #
  def pick_teacher
    @activity = @course.activities.find params[:id]
    @teachers = User.teachers
    @indexes = TimetablesOnRails::FirstLetterIndex.build_from_name @teachers
  end

  ##
  #
  # Assigns a teacher to a specific activity.
  # This action requires either the user to be the course's manager or administrative privileges.
  #
  def choose_teacher
    activity = Activity.find_by_id params[:id]
    candidate = User.teachers.find params[:teacher]
    Notification.notify_activity_teacher_chosen @school_year, current_user, candidate, activity
    activity.assign! candidate
    activity.save!

    flash[:success] = "#{candidate.name} a été accepté pour enseigner l'activité #{activity.type} de l'E.C #{activity.course.name}"
    redirect_to school_year_course_path(@school_year, @course) 
  end

  ##
  #
  # Removes a candidate from the activity's candidates list.
  #
  def dismiss_candidate
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.dismiss_candidate candidate
    activity.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature à l'E.C #{course.name} pour l'activité #{activity.type}"
    redirect_to :back
  end

  ##
  #
  # Removes a teacher from the activity's teachers list.
  #
  def dismiss_teacher
    activity = Activity.find_by_id params[:id]
    teacher = activity.teachers.find params[:teacher]
    activity.dismiss_teacher teacher
    activity.save!

    flash[:success] = "#{teacher.name} est a été retiré de la liste des enseignants de l'activité #{activity.type} de l'E.C #{activity.course.name}"
    redirect_to :back
  end

  ##
  #
  # Adds the current user to the activity's candidates list, unless she
  # is already a candidate, in which case it renders an error message.
  #
  def apply
    activity = Activity.find_by_id params[:id]

    unless current_user.applied_to_activity_teaching? activity
      Notification.notify_new_activity_candidate @school_year, current_user, activity
      current_user.apply_to_activity_teaching activity

      flash[:success] = "Votre candidature pour enseigner l'activité #{activity.type} de l'E.C #{activity.course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous avez déjà postulé pour enseigner l'activité #{activity.type} de l'E.C #{activity.course.name}."
    end
  end

  ##
  #
  # Removes the current user from the activity's candidates list if
  # she has applied, otherwise it renders an error message.
  #
  def withdraw
    activity = Activity.find_by_id params[:id]
    
    if current_user.applied_to_activity_teaching? activity
      current_user.withdraw_activity_teaching_application activity
      Notification.notify_withdraw_activity_teaching_application @school_year, current_user, activity

      flash[:success] = "Votre candidature à la gestion de l'activité #{activity.type} de l'E.C #{activity.course.name} a été retirée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'avez pas postulé à la gestion de l'activité #{activity.type} de l'E.C #{activity.course.name}."
    end
  end

  ##
  #
  # Removes the current user from the activity's teachers list.
  #
  def resign
    activity = Activity.find_by_id params[:id]
    
    if current_user.teaches? activity
      Notification.notify_activity_teacher_resigned @school_year, current_user, activity
      current_user.resign_as_teacher activity

      flash[:success] = "Votre démission du poste d'enseignant de l'activité #{activity.type} de l'E.C #{activity.course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'êtes pas enseignant de l'activité #{activity.type} de l'E.C #{activity.course.name}."
    end
  end

  ##
  #
  # Destroys the activity and its related data.
  #
  def destroy
    activity = Activity.find_by_id! params[:id]
    activity.destroy
    flash[:success] = "L'activité #{activity.type} de l'E.C #{activity.course.name} a été supprimée avec succès."
    redirect_to :back
  end

  private

  def load_school_year_and_course
    @school_year = SchoolYearManager.instance.find! params[:school_year_id]
    @course = Course.find_by_id params[:course_id]
  end
end
