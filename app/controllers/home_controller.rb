# encoding: utf-8
class HomeController < ApplicationController

  def dashboard
    @active_school_year = SchoolYearManager.instance.active_school_year
    params[:depuis] ||= '2-semaines'

    notifications = case params[:depuis]
                      when '1-semaine'
                        @active_school_year.notifications.last_week
                      when '2-semaines'
                        @active_school_year.notifications.last_two_weeks
                      when '1-mois'
                        @active_school_year.notifications.last_month
                      when '3-mois'
                        @active_school_year.notifications.last_three_months
                      else
                        @active_school_year.notifications.last_two_weeks
                    end

    if current_user.administrator?
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(notifications.map {|n| NotificationPresenter.new n})
      render 'administrator_dashboard'
    else
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(notifications.related_to_user(current_user).map {|n| NotificationPresenter.new n})
      @responsabilities = current_user.responsabilities.map { |c| CoursePresenter.new c }
      @activities = current_user.activities.map { |activity| ActivityItemPresenter.new activity }
      render 'teacher_dashboard'
    end
  end

end
