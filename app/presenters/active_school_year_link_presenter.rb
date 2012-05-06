class ActiveSchoolYearLinkPresenter

  def self.render(context)
    @active_school_year = SchoolYearManager.instance.active_school_year
    context.render (@active_school_year ? 'layouts/active_school_year_link' : 'layouts/no_active_school_year_link'), active_school_year: @active_school_year
  end
end
