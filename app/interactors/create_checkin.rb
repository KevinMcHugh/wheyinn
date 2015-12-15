class CreateCheckin

  def self.call(person, event, weight)
    return if ENV['QUIET_MODE']
    previous_checkin = Checkin.where(person: person, event: event).first
    delta = nil
    delta = weight - previous_checkin.weight if previous_checkin
    Checkin.create(person: person, event: event, weight: weight, delta: delta)
    if person.starting_weight
      person.up_by = weight - person.starting_weight
    else
      person.starting_weight = weight
    end
    person.save
  end
end