# encoding: utf-8
class ActivitiesController < ApplicationController

  before_filter :load_active_year

  def index
    @activity = Activity.new
  end

  def create
    @activity = @active_school_year.find_semester(params[:semester_id]).find_course(params[:course][:name]).new_activity(params[:type], params[:duration], params[:groups])

    if @activity.save
      flash[:success] = "#{@activity.type} a été ajouté avec succès au cours #{@activity.courses.name}."
      redirect_to active_school_year_path
    else
      render 'index'
    end
  end
	
	# La liste des profs dépend de l'activité en question (donc du nombre de groupe)
  def choose_activity_teacher
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.assign! candidate
    activity.save!

    flash[:success] = "#{candidate.name} postule pour enseigner dans l'U.E #{course.name} pour l'activité #{activity.type}"
    redirect_to active_school_year_path
  end

  def dismiss_candidate
    activity = Activity.find_by_id params[:id]
    candidate = activity.candidates.find params[:candidate]
    activity.dismiss_candidate candidate
    activity.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature à l'U.E #{course.name} pour l'activité #{activity.type}"
    redirect_to active_school_year_path
  end

  def destroy
    activity = Activity.find_by_id params[:id]
    activity.destroy
    flash[:success] = "L'activité #{activity.name} pour l'U.E #{course.name} a été supprimée avec succès."
    redirect_to active_school_year_path
  end

  private

  def load_active_year
    @active_school_year = SchoolYearManager.instance.active_school_year
    @semesters = @active_school_year.semesters
  end
end
