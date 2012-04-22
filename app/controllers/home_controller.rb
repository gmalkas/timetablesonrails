# encoding: utf-8
class HomeController < ApplicationController

  def dashboard
    @active_school_year = SchoolYearManager.instance.active_school_year

    if current_user.administrator?
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(@active_school_year.notifications.map {|n| NotificationPresenter.new n})
      render 'administrator_dashboard'
    else
      @notifications = TimetablesOnRails::DateRegroup.group_by_day(@active_school_year.notifications.related_to_user(current_user).map {|n| NotificationPresenter.new n})
      render 'teacher_dashboard'
    end
  end

end
