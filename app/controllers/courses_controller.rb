# encoding: utf-8
require_relative '../models/notifications/new_course_candidate'

class CoursesController < ApplicationController

  before_filter :load_active_year

  authorize_resource

  def index
    @course = Course.new
  end

  def create
    @course = @active_school_year.find_semester(params[:semester_id]).new_course(params[:course][:name])

    if @course.save
      flash[:success] = "#{@course.name} a été ajouté avec succès au semestre #{@course.semester.name}."
      redirect_to active_school_year_path
    else
      render 'index'
    end
  end

  def choose_course_manager
    course = Course.find_by_id params[:id]
    candidate = course.candidates.find params[:candidate]
    course.assign! candidate
    course.save!

    flash[:success] = "#{candidate.name} est désormais responsable de l'U.E #{course.name}."
    redirect_to active_school_year_path
  end

  def dismiss_candidate
    course = Course.find_by_id params[:id]
    candidate = course.candidates.find params[:candidate]
    course.dismiss_candidate candidate
    course.save!

    flash[:success] = "#{candidate.name} est a été retiré de la liste de candidature de l'U.E #{course.name}."
    redirect_to active_school_year_path
  end

  def apply
    course = Course.find_by_id params[:id]

    unless current_user.applied? course
      current_user.apply_to_course_management course
      Notification.notify_new_course_candidate @active_school_year, current_user, course

      flash[:success] = "Votre candidature à la gestion de l'U.E #{course.name} a été enregistrée."
      redirect_to active_school_year_path
    else
      redirect_to active_school_year_path, alert: "Vous avez déjà postulé à la gestion de l'U.E #{course.name}."
    end
  end

  def withdraw
    course = Course.find_by_id params[:id]
    
    if current_user.applied? course
      current_user.withdraw_course_management_application course
      Notification.notify_withdraw_course_management_application  @active_school_year, current_user, course

      flash[:success] = "Votre candidature à la gestion de l'U.E #{course.name} a été retirée."
      redirect_to active_school_year_path
    else
      redirect_to active_school_year_path, alert: "Vous n'avez pas postulé à la gestion de l'U.E #{course.name}."
    end

  end

  def destroy
    course = Course.find_by_id params[:id]
    course.destroy
    flash[:success] = "L'unité d'enseignement #{course.name} a été supprimé avec succès."
    redirect_to active_school_year_path
  end

  private

  def load_active_year
    @active_school_year = SchoolYearManager.instance.active_school_year

    unless @active_school_year.nil?
      @semesters = @active_school_year.semesters
    else
      redirect_to root_path, alert: "Il n'existe aucune année active !"
    end
  end
end
