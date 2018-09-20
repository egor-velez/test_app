require 'rails_helper'

RSpec.describe ShopsBooksInfo, type: :model do
  describe '#sell(number_of_copies)' do
    subject(:shops_books_info) { create :shops_books_info }
    it { expect { subject.sell(3) }.to change { subject.in_stock }.by(-3) }
    it { expect { subject.sell(4) }.to change { subject.sold }.by(4) }
    it "Validate In Stock" do
      subject.sell(1000)
      subject.valid?
      expect(subject.errors[:in_stock]).to include('must be greater than or equal to 0')
    end
  end
end
