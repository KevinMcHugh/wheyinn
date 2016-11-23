require 'spec_helper'

describe CreateCheckin do
  let(:user) { User.create(email: 'tester@murphyweighin.com', password: 'eat2compete') }
  let(:person) { Person.create }
  let(:event) { Event.create(name: '1')}

  describe '#call' do
    subject { described_class.call(person, event, 200, user) }
    it 'creates a new Checkin' do
      expect{subject}.to change{Checkin.count}.by(1)
    end
    it 'joins the user and person' do
      subject
      expect(user.people).to include(person)
    end
    context 'when there is only one checkin' do
     it 'does not send mail' do
        expect(NewTopScoreMailer).to receive(:email)
        subject
      end
    end
    context 'when the person takes lead' do
      context 'with multiple people' do
        let(:leader) { Person.create }
        it 'sends mail' do
          described_class.call(leader, event, 100, user)
          described_class.call(leader, event, 200, user)
          described_class.call(person, event, 50, user)
          expect(NewTopScoreMailer).to receive(:email)
          subject
        end
      end
      context 'with only one person' do

      end
    end
    context 'when the person does not take the lead' do
      let(:leader) { Person.create }
      it 'does not send mail' do
        described_class.call(leader, event, 100, user)
        described_class.call(leader, event, 300, user)
        described_class.call(person, event, 50, user)
        expect(NewTopScoreMailer).not_to receive(:email)
        expect(NewTopScoreMailer).not_to receive(:send)
        subject
      end
    end
    context 'when the user and person are already joined' do
      before { UserPersonJoin.create!(user: user, person: person) }
      it 'does not join them again' do
        expect{subject}.not_to change{UserPersonJoin.count}
      end
      it 'updates the times_used count' do
        subject
        expect(user.user_person_joins.find_by(person: person).times_used).to eql(2)
      end
    end
  end
end
