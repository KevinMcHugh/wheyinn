class NewTopScoreMailer < ApplicationMailer
  def email(person, previously_in_first=nil)
    @person = person
    @previously_in_first = previously_in_first
    mail(to: 'kev@kevinmchugh.me', subject: "#{person.name} has taken the lead!")
  end
end
