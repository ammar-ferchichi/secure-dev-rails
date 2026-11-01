module Secure
  class ProfilesController < ApplicationController
    def show
    end

    # Mass assignment — fixed: strong parameters allow only display_name.
    # A role=admin parameter is silently dropped.
    def update
      Current.user.update!(profile_params)
      redirect_to secure_profile_path, notice: "Profile updated."
    end

    private
      def profile_params
        params.require(:user).permit(:display_name)
      end
  end
end
