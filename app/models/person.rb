class Person < ActiveRecord::Base

  has_many :checkins
  has_many :user_person_joins
  has_many :users, through: :user_person_joins

  def percentage_change
    return unless up_by
    @percentage_change ||= starting_weight ?  sprintf('%4s',sprintf('%0.4g', (up_by / starting_weight * 100))) : nil
  end

  def checkin_diffs
    grouped = checkins.group_by(&:event)
    event_diffs = {}
    grouped.each_pair do |event, checkins|
      diffs = checkins.map(&:delta).compact
      event_diffs[event.try(:name)] = diffs.map { |d| '%.2f' % d }
    end
    event_diffs
  end
end
