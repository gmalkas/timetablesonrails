# encoding: utf-8
class ActivitiesController < ApplicationController

  before_filter :load_school_year_and_course

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

  def pick_teacher
    @activity = Activity.find_by_id params[:id]
    @teachers = User.teachers
    @indexes = TimetablesOnRails::FirstLetterIndex.build_from_name @teachers
  end

  def choose_teacher
    activity = Activity.find_by_id params[:id]
    candidate = User.teachers.find params[:teacher]
    activity.assign! candidate
    activity.save!

    flash[:success] = "#{candidate.name} a été accepté pour enseigner l'activité #{activity.type} de l'E.C #{activity.course.name}"
    redirect_to school_year_course_path(@school_year, @course) 
  end

  def dismiss_candidate
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.dismiss_candidate candidate
    activity.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature à l'E.C #{course.name} pour l'activité #{activity.type}"
    redirect_to :back
  end

  def dismiss_teacher
    activity = Activity.find_by_id params[:id]
    teacher = activity.teachers.find params[:teacher]
    activity.dismiss_teacher teacher
    activity.save!

    flash[:success] = "#{teacher.name} est a été retiré de la liste des enseignants de l'activité #{activity.type} de l'E.C #{activity.course.name}"
    redirect_to :back
  end

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

  def withdraw
    activity = Activity.find_by_id params[:id]
    
    if current_user.applied_to_activity_teaching? activity
      current_user.withdraw_activity_teaching_application activity

      flash[:success] = "Votre candidature à la gestion de l'activité #{activity.type} de l'E.C #{activity.course.name} a été retirée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'avez pas postulé à la gestion de l'activité #{activity.type} de l'E.C #{activity.course.name}."
    end
  end

  def resign
    activity = Activity.find_by_id params[:id]
    
    if current_user.teaches? activity
      current_user.resign_as_teacher activity

      flash[:success] = "Votre démission du poste d'enseignant de l'activité #{activity.type} de l'E.C #{activity.course.name} a été enregistrée."
      redirect_to :back
    else
      redirect_to :back, alert: "Vous n'êtes pas enseignant de l'activité #{activity.type} de l'E.C #{activity.course.name}."
    end
  end

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
