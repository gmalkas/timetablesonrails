# encoding: utf-8

##
# = Home Controller
#
# Renders a user-specific dashboard. There are two kinds of dashboard : one for 
# administrators and one for teachers.
#
class HomeController < ApplicationController

  def dashboard
    @school_year = SchoolYearManager.instance.active_school_year

    params[:depuis] ||= '2-semaines'

    notifications = Array.new
    
    # TODO: this 'switch' does not belong in a controller
    # It probably should be moved to a 'lib' class.
    notifications = case params[:depuis]  
                      when '1-semaine'
                        @school_year.notifications.last_week
                      when '2-semaines'
                        @school_year.notifications.last_two_weeks
                      when '1-mois'
                        @school_year.notifications.last_month
                      when '3-mois'
                        @school_year.notifications.last_three_months
                      else
                        @school_year.notifications.last_two_weeks
                    end if @school_year

    if current_user.administrator?
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(notifications.map {|n| NotificationPresenter.new n})
      render 'administrator_dashboard'
    else
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(notifications.related_to(current_user).map {|n| NotificationPresenter.new n})
      @responsabilities = current_user.responsabilities.map { |c| CoursePresenter.new c }
      @activities = current_user.activities.map { |activity| ActivityItemPresenter.new activity }
      render 'teacher_dashboard'
    end
  end

end
