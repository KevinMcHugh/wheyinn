class CreateCheckin

  def self.call(person, event, weight)
    previous_checkin = Checkin.where(person: person, event: event).last
    delta = nil
    delta = weight - previous_checkin.weight if previous_checkin
    Checkin.create(person: person, event: event, weight: weight, delta: delta)
  end
end