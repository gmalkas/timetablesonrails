# encoding: utf-8
class SchoolYearsController < ApplicationController

  before_filter :load_school_years

  rescue_from ActiveRecord::RecordNotFound, :with => :school_year_not_found

  def index
    @school_year = SchoolYearManager.instance.new_school_year
    @active_school_year = SchoolYearManager.instance.active_school_year
  end

  def create
    @school_year = SchoolYearManager.instance.new_school_year params[:school_year][:start_year]

    if @school_year.save
      redirect_to school_years_path, notice: "L'année a été ajoutée avec succès."
    else
      render 'index'
    end
  end

  def activate
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.activate_school_year school_year
    flash[:success] = "L'année a été activée."
    redirect_to school_years_path, success:
  end

  def disable
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.disable_school_year school_year
    redirect_to school_years_path, notice: "L'année a été désactivée."
  end

  def destroy
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.destroy_school_year school_year
    redirect_to school_years_path, notice: "L'année a été supprimée."
  end

  private
  
  def load_school_years
    @school_years = SchoolYearManager.instance.school_years
    @archived_school_years = @school_years.select { |sc| sc.archived? } 
    @disabled_school_years = @school_years.select { |sc| not sc.activated? } - @archived_school_years
  end

  def school_year_not_found
    redirect_to school_years_path, alert: "Année scolaire inexistante."
  end
end
