class Person < ActiveRecord::Base

  has_many :checkins

  def up_by
    return nil unless starting_weight
    current_weight  = checkins.last.try(:weight) || 0
    current_weight - starting_weight
  end

  def percentage_change
    starting_weight ? '%.2f' % (up_by / starting_weight * 100) : nil
  end

  private
  def starting_weight
    checkins.first.try(:weight)
  end
end
