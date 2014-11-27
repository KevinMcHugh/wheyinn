class PeopleController < ApplicationController

  def create
    @person = Person.create(person_params)
    @person.checkins.create(checkin_params)
    redirect_to people_path
  end

  def index
    @people = Person.all
  end

  private
  def person_params
    params.required(:person).permit([:name])
  end

  def checkin_params
    params.required(:person).permit([:weight])
  end
end