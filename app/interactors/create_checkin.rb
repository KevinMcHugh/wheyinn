class CreateCheckin

  def self.call(person, event, weight, current_user)
    return if ENV['QUIET_MODE']
    previously_in_first = Event.last.people.sort_by{|p| p.up_by || -1000 }.last

    previous_checkin = Checkin.where(person: person, event: event).first
    delta = nil
    delta = weight - previous_checkin.weight if previous_checkin
    Checkin.create(person: person, event: event, weight: weight, delta: delta, user: current_user)
    if person.starting_weight
      person.up_by = weight - person.starting_weight
    else
      person.starting_weight = weight
    end
    person.save

    if current_user && !current_user.people.include?(person)
      current_user.user_person_joins.create(person: person)
    elsif current_user.people.include?(person)
      join = current_user.user_person_joins.find_by(person: person)
      join.times_used += 1
      join.save
    end

    send_mail_maybe(person, event, previously_in_first)
  end

  def self.send_mail_maybe(person, event, previously_in_first)
    return if ENV['NO_MAIL'] == 'true'
    if !previously_in_first
      NewTopScoreMailer.email(person).deliver_now
    elsif person.up_by && person != previously_in_first && person.up_by >= previously_in_first.up_by
      tie = person.up_by == previously_in_first.up_by
      NewTopScoreMailer.email(person, previously_in_first).deliver_now
      previously_in_first.users.map do |user|
        NewTopScoreMailer.no_longer_first_email(user.email, person, previously_in_first, tie).deliver_now
      end
      person.users.map do |user|
        NewTopScoreMailer.now_in_first_email(user.email, person, previously_in_first, tie).deliver_now
      end
    end
  rescue
  end
end