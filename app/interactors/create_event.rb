class CreateEvent

  def self.call(name)
    Event.create(name: name)
    Person.find_each do |p|
      p.starting_weight = nil
      p.up_by = nil

      p.save
    end
  end
end