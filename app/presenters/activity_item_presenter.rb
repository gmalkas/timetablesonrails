class ActivityItemPresenter
  attr_accessor :activity

  def initialize(activity)
    @activity = activity
  end

  def render(context, show_course_name=false)
    # if @activity.assigned?
    #   context.render 'activities/assigned_activity_item', activity: activity
    # else
    #   context.render 'activities/activity_item', activity: activity
    # end
    context.render 'activities/activity_item', activity: activity, show_course_name: show_course_name
  end

end
