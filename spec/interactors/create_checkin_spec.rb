require 'spec_helper'

describe CreateCheckin do
  let(:user) { User.create(email: 'tester@murphyweighin.com', password: 'eat2compete') }
  let(:person) { Person.create }
  let(:event) { Event.create(name: '1')}

  describe '#call' do
    subject { described_class.call(person, event, 100, user) }
    it 'creates a new Checkin' do
      expect{subject}.to change{Checkin.count}.by(1)
    end

    it 'joins the user and person' do
      subject
      expect(user.people).to include(person)
    end
    context 'when the user and person are already joined' do
      it 'does not join them again' do
        UserPersonJoin.create!(user: user, person: person)
        expect{subject}.not_to change{UserPersonJoin.count}
      end
    end
  end
end
