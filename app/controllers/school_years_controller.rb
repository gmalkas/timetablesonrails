# encoding: utf-8
class SchoolYearsController < ApplicationController

  before_filter :load_school_years

  rescue_from ActiveRecord::RecordNotFound, :with => :school_year_not_found

  def index
    @school_year = SchoolYearManager.instance.build_school_year
  end

  def create
    @school_year = SchoolYearManager.instance.build_school_year params[:school_year][:start_year]

    if @school_year.valid?
      SchoolYearManager.instance.new_school_year @school_year
      flash[:success] = "L'année a été ajoutée avec succès."
      redirect_to school_years_path
    else
      render 'index'
    end
  end

  def activate
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.activate_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été activée."
    redirect_to school_years_path
  end

  def disable
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.disable_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été désactivée."
    redirect_to school_years_path
  end

  def archive
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.archive_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été archivée."
    redirect_to school_years_path
  end

  def restore
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.restore_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été restaurée."
    redirect_to school_years_path
  end

  def destroy
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.destroy_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été supprimée."
    redirect_to school_years_path
  end

  private
  
  def load_school_years
    @school_years = SchoolYearManager.instance.school_years
    @active_school_year = SchoolYearManager.instance.active_school_year
    @archived_school_years = @school_years.select { |sc| sc.archived? } 
    @disabled_school_years = @school_years.select { |sc| not sc.activated? } - @archived_school_years
  end

  def school_year_not_found
    redirect_to school_years_path, alert: "Année scolaire inexistante : #{params[:id] }"
  end
end
