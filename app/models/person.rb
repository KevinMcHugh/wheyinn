class Person < ActiveRecord::Base

  has_many :checkins

  def up_by
    return @up_by if @up_by
    return 0.0 unless starting_weight
    current_weight = current_checkins.last.try(:weight) || 0
    @up_by ||= current_weight - starting_weight
  end

  def percentage_change
    @percentage_change ||= starting_weight ? '%.2f' % (up_by / starting_weight * 100) : nil
  end

  def checkin_diffs
    grouped = checkins.group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, checkins|
      event_diffs[event.try(:name)] = checkins.map(&:delta).compact
    end
    event_diffs
  end

  def starting_weight
    if current_checkins
      current_checkins.first.try(:weight)
    end
  end

  def current_checkins
    Event.last.checkins.where(person_id: id)
  end
end
