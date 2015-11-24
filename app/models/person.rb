class Person < ActiveRecord::Base

  has_many :checkins

  def up_by
    return nil unless starting_weight
    current_weight  = current_checkins.last.try(:weight) || 0
    current_weight - starting_weight
  end

  def percentage_change
    starting_weight ? '%.2f' % (up_by / starting_weight * 100) : nil
  end

  def checkin_diffs
    return [] unless checkins.size > 1
    grouped = checkins.group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, event_checkins|
      if event_checkins.size <= 1
        next
      else
        prev = event_checkins.first.try(:weight)
        diffs = event_checkins.map(&:weight).map do |w|
          n = w - prev
          prev = w
          n
        end
        diffs = diffs.last(diffs.length - 1)
        event_diffs[event.try(:name)] = diffs.map { |bd| '%.2f' % bd }
      end
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
