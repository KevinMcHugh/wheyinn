require 'spec_helper'

describe Person do
  subject { Person.create }
  let(:e1) { Event.create(name: '1')}
  let(:c1) { Checkin.create(person: subject, weight: 100, event: e1)}
  let(:c2) { Checkin.create(person: subject, weight: 200, event: e1)}
  let(:c3) { Checkin.create(person: subject, weight: 250, event: e1)}

  let(:e2) { Event.create(name: '2')}
  let(:c4) { Checkin.create(person: subject, weight: 101, event: e2)}
  let(:c5) { Checkin.create(person: subject, weight: 202, event: e2)}
  let(:c6) { Checkin.create(person: subject, weight: 303, event: e2)}

  describe '#up_by' do
    context 'with 0 checkins' do
      it 'returns nil' do
        expect(subject.up_by).to be_nil
      end
    end
    context 'with one checkin' do
      before { c1 }
      it 'returns 0' do
        expect(subject.up_by).to eql(0)
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
        expect(subject.percentage_change).to eq('0.00')
      end
    end
    context 'with two checkins' do
      before { c1; c2 }
      it 'calculates the difference between first and last Checkin' do
        expect(subject.percentage_change).to eq('100.00')
      end
    end
    context 'with many checkins' do
      before { c1; c2; c3}
      it 'calculates the difference between first and last Checkin' do
        expect(subject.percentage_change).to eq('150.00')
      end
    end
    context 'with many events' do
      before { c4; c5; c6 }
      it 'only uses the checkins from the last event' do
        expect(subject.percentage_change).to eql('200.00')
      end
    end
  end
  describe '#checkin_diffs' do
    before {c1; c2; c3}
    it 'gives the difference between checkins, in order' do
      expect(subject.checkin_diffs).to eql({"1" => ['100.00','50.00']})
    end
    context 'with many events' do
      before { c4; c5; c6 }
      it 'maps the events to the checkins' do
        expect(subject.checkin_diffs).to eql({"1" => ['100.00','50.00'], "2" => ['101.00', '101.00']})
      end
    end
  end
end
