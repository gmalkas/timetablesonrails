class ActivityItemPresenter
  attr_accessor :activity

  def initialize(activity)
    @activity = activity
  end

  def render(context)
    # if @activity.assigned?
    #   context.render 'activities/assigned_activity_item', activity: activity
    # else
    #   context.render 'activities/activity_item', activity: activity
    # end
    context.render 'activities/activity_item', activity: activity
  end

end
