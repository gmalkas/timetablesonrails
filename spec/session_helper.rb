##
# This helper is used when an active session is necessary.
#
def stub_session(context, user=User.new)
  context.stub(:current_user) { user }
end
