class CheckinsController < ApplicationController

  def create
    @checkin = Checkin.create(checkin_params)
    redirect_to people_path
  end

  def new
    @person_id = params[:person_id]
  end

  private
  def checkin_params
    params.required(:checkin).permit([:weight, :person_id])
  end
end