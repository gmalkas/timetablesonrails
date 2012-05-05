##
# = UserObserver
# Destroys notification related to a destroyed user.
#
class UserObserver < ActiveRecord::Observer

  def after_destroy(user)
    Notification.related_to_user(user).destroy_all
  end
end
