class SchoolYearsController < ApplicationController
  def index
    @school_years = SchoolYearManager.instance.school_years
  end
end
