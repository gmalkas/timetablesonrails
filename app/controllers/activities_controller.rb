# encoding: utf-8
class ActivitiesController < ApplicationController

  before_filter :load_active_year_and_course

  def new
    @activity = @course.activities.build
  end

  def create
    @activity = @course.new_activity params[:activity][:type], params[:activity][:groups], params[:activity][:duration]

    if @activity.save
      flash[:success] = "L'activité #{@activity.type} a été ajouté avec succès au cours #{@course.name}."
      redirect_to @course
    else
      render 'new'
    end
  end

  def choose_activity_teacher
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.assign! candidate
    activity.save!

    flash[:success] = "#{candidate.name} a été accepté pour enseigner l'activité #{activity.type} de l'U.E #{activity.course.name}"
    redirect_to :back
  end

  def dismiss_candidate
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.dismiss_candidate candidate
    activity.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature à l'U.E #{course.name} pour l'activité #{activity.type}"
    redirect_to active_school_year_path
  end

  def dismiss_teacher
    activity = Activity.find_by_id params[:id]
    teacher = activity.teachers.find params[:teacher]
    activity.dismiss_teacher teacher
    activity.save!

    flash[:success] = "#{teacher.name} est a été retiré de la liste des enseignants de l'activité #{activity.type}"
    redirect_to @course
  end

  def apply
    activity = Activity.find_by_id params[:id]

    unless current_user.applied_to_activity_teaching? activity
      current_user.apply_to_activity_teaching activity

      flash[:success] = "Votre candidature pour enseigner l'activité #{activity.type} de l'U.E #{activity.course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous avez déjà postulé pour enseigner l'activité #{activity.type} de l'U.E #{activity.course.name}."
    end
  end

  def withdraw
    activity = Activity.find_by_id params[:id]
    
    if current_user.applied? course
      current_user.withdraw_course_management_application course
      Notification.notify_withdraw_course_management_application  @active_school_year, current_user, course

      flash[:success] = "Votre candidature à la gestion de l'U.E #{course.name} a été retirée."
      redirect_to active_school_year_path
    else
      redirect_to active_school_year_path, alert: "Vous n'avez pas postulé à la gestion de l'U.E #{course.name}."
    end
  end

  def resign
    course = Course.find_by_id params[:id]
    
    if current_user.manage? course
      current_user.resign_as_manager course
      Notification.notify_course_manager_resigned  @active_school_year, current_user, course

      flash[:success] = "Votre démission du poste de responsable de l'U.E #{course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'êtes pas responsable de l'U.E #{course.name}."
    end
  end

  def destroy
    activity = Activity.find_by_id params[:id]
    activity.destroy
    flash[:success] = "L'activité #{activity.type} de l'U.E #{activity.course.name} a été supprimée avec succès."
    redirect_to @course
  end

  private

  def load_active_year_and_course
    @active_school_year = SchoolYearManager.instance.active_school_year
    @course = Course.find_by_id params[:course_id]
  end
end
