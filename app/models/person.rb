class Person < ActiveRecord::Base

  has_many :checkins
  def up_by
    starting_weight = checkins.first.try(:weight)
    return nil unless starting_weight
    current_weight  = checkins.last.try(:weight) || 0
    current_weight - starting_weight
  end
end
