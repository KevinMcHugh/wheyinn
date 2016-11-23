require 'spec_helper'

describe Person do
  subject { Person.create }
  let(:e1) { Event.create(name: '1', created_at: 1.year.ago)}
  let(:user) { User.create(email: 'tester@murphyweighin.com', password: 'eat2compete') }
  let(:c1) { CreateCheckin.call(subject, e1, 100, user)}
  let(:c2) { CreateCheckin.call(subject, e1, 200, user)}
  let(:c3) { CreateCheckin.call(subject, e1, 250, user)}

  let(:e2) { Event.create(name: '2', created_at: 1.day.ago)}
  let(:c4) { CreateCheckin.call(subject, e2, 101, user)}
  let(:c5) { CreateCheckin.call(subject, e2, 202, user)}
  let(:c6) { CreateCheckin.call(subject, e2, 303, user)}

  describe '#up_by' do
    context 'with 0 checkins' do
      it 'returns nil' do
        expect(subject.up_by).to be_nil
      end
    end
    context 'with one checkin' do
      before { c1 }
      it 'returns 0' do
        expect(subject.up_by).to be_nil
      end
    end
    context 'with two checkins' do
      before { c1; c2 }
      it 'calculates the difference between first and last Checkin' do
        expect(subject.up_by).to eql(100)
      end
    end
    context 'with many checkins' do
      before { c1; c2; c3}
      it 'calculates the difference between first and last Checkin' do
        expect(subject.up_by).to eql(150)
      end
    end
    context 'with many events' do
      before { c4; c5; c6 }
      it 'only uses the checkins from the last event' do
        expect(subject.up_by).to eql(202)
      end
    end
  end
  describe '#percentage_change' do
   context 'with 0 checkins' do
      it 'returns nil' do
        expect(subject.percentage_change).to be_nil
      end
    end
    context 'with one checkin' do
      before { c1 }
      it 'returns 0' do
        expect(subject.percentage_change).to be_nil
      end
    end
    context 'with two checkins' do
      before { c1; c2 }
      it 'calculates the difference between first and last Checkin' do
        expect(subject.percentage_change.to_f).to eq(100.0)
      end
    end
    context 'with many checkins' do
      before { c1; c2; c3}
      it 'calculates the difference between first and last Checkin' do
        expect(subject.percentage_change.to_f).to eq(150.0)
      end
    end
    context 'with many events' do
      before { c4; c5; c6 }
      it 'only uses the checkins from the last event' do
        expect(subject.percentage_change.to_f).to eql(200.0)
      end
    end
  end
  describe '#checkin_diffs' do
    # TODO: order checkins by event date...
    context 'with one event' do
      before {c1; c2; c3}
      it 'gives the difference between checkins, in order' do
        expect(subject.checkin_diffs).to eql({"1" => ['100.00','150.00']})
      end
    end
    context 'with many events' do
      before { c4; c5; c6; c1; c2; c3; }
      it 'maps the events to the checkins' do
        expect(subject.checkin_diffs).to eql({"1" => ['100.00','150.00'], "2" => ['101.00', '202.00']})
      end
    end
  end
end
