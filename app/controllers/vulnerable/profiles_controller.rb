# INTENTIONALLY VULNERABLE — see app/controllers/secure/profiles_controller.rb for the fix.
module Vulnerable
  class ProfilesController < BaseController
    # A01 Broken Access Control via mass assignment — permit! lets a user send role=admin.
    def update
      Current.user.update!(params.require(:user).permit!)
      redirect_to secure_profile_path, notice: "Profile updated."
    end
  end
end
