require 'rails_helper'

RSpec.describe Guest, :type => :model do

  describe '#add_phones!' do
    context 'empty phone case' do
      let(:params) { {} }
      let(:new_phones) { ['628123456789'] }
      subject { described_class.new(params) }
      it do
        subject.add_phones!(new_phones)
        expect(subject[:phone]).to eq('["628123456789"]')
      end
    end

    context 'not empty phone case' do
      let(:params) { { phone: ['628123456789'] } }
      let(:new_phones) { ['6281987654321'] }
      subject { described_class.new(params) }
      it do
        subject.add_phones!(new_phones)
        expect(subject[:phone]).to eq('["628123456789", "6281987654321"]')
      end
    end

    context 'duplicate case' do
      let(:params) { { phone: ['628123456789'] } }
      let(:new_phones) { ['628123456789'] }
      subject { described_class.new(params) }
      it do
        subject.add_phones!(new_phones)
        expect(subject[:phone]).to eq('["628123456789"]')
      end
    end
  end
end