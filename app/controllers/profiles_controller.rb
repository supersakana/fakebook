class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[update]

  def update
    if @profile.update(profile_params)
      attach_img
      redirect_to @profile.user
    else
      redirect_to request.referrer, status: :see_other
    end
  end

  def edit; end

  private

  def attach_img
    if params[:profile][:default_image] == '1'
      @profile.image.destroy
    elsif !params[:profile][:image].nil?
      @profile.image.attach(params[:profile][:image])
    end
  end

  def profile_params
    params.require(:profile).permit(:full_name, :location, :link, :bio, :color, :image)
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end
end
