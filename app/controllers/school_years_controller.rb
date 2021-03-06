# encoding: utf-8

##
#
# = SchoolYearsController
#
# Handles common CRUD functions for school years, as well as specific operations
# such as archiving and activating school years. This controller is only
# available to administrator.
# 
class SchoolYearsController < ApplicationController

  before_filter :load_school_years

  authorize_resource

  rescue_from ActiveRecord::RecordNotFound, :with => :school_year_not_found

  def index
    @school_year = SchoolYearManager.instance.build_school_year
  end

  def create
    @school_year = SchoolYearManager.instance.build_school_year params[:school_year][:start_year]

    if @school_year.valid?
      SchoolYearManager.instance.new_school_year @school_year
      if params[:import] == '1'
        @imported_school_year = SchoolYearManager.instance.find_by_id!(params[:import_year])
        @school_year.import_from @imported_school_year
      end
      flash[:success] = "L'année a été ajoutée avec succès."
      redirect_to school_years_path
    else
      render 'index'
    end
  end

  ##
  #
  # Activates the school year.
  #
  # == See also
  #
  # SchoolYear for more information about the 'active' state.
  #
  def activate
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.activate_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été activée."
    redirect_to school_years_path
  end

  ##
  #
  # Disables the school year.
  #
  # == See also
  #
  # SchoolYear for more information about the 'disabled' state.
  #
  def disable
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.disable_school_year
    flash[:success] = "L'année #{params[:id]} a correctement été désactivée."
    redirect_to school_years_path
  end

  ##
  # 
  # Archives the school year.
  #
  # == See also
  #
  # SchoolYear for more information about the 'archived' state.
  #
  def archive
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.archive_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été archivée."
    redirect_to school_years_path
  end

  ##
  #
  # Restores the school year from the archives.
  #
  # == See also
  #
  # SchoolYear for more information about the 'disabled' state.
  #
  def restore
    school_year = SchoolYearManager.instance.find! params[:id]
    SchoolYearManager.instance.restore_school_year school_year
    flash[:success] = "L'année #{params[:id]} a correctement été restaurée."
    redirect_to school_years_path
  end

  ##
  #
  # Destroys the school year and all its related data.
  #
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
