##
#
# = ActiveSchoolYearLinkPresenter
#
# Encapsulate the knowledge associated with the concept of linking to the 'active year'.
#
# == See also
#
# SchoolYear for more information about the 'active' state.
#
class ActiveSchoolYearLinkPresenter

  ##
  #
  # Renders the link to the active school year if there is one, or a link to
  # root_path if there is none.
  #
  def self.render(context)
    @active_school_year = SchoolYearManager.instance.active_school_year
    context.render (@active_school_year ? 'layouts/active_school_year_link' : 'layouts/no_active_school_year_link'), active_school_year: @active_school_year
  end
end
