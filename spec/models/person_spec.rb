require 'spec_helper'

describe Person do
  subject { Person.create }
  let(:c1) { Checkin.create(person: subject, weight: 100)}
  let(:c2) { Checkin.create(person: subject, weight: 200)}
  let(:c3) { Checkin.create(person: subject, weight: 300)}
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
        expect(subject.up_by).to eql(200)
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
        expect(subject.percentage_change).to eq('200.00')
      end
    end
  end
end
