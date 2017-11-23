class LocationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def create
    @location = Location.create(location_params)
    redirect_to new_checkin_path(location_id: @location.id, person_id: params[:person_id], weight: params[:weight])
  end

  def index
    @locations = Location.all
  end

  def show
    @location = Location.find(params[:id])
  end

  private
  def location_params
    params.required(:location).permit([:name])
  end
end
