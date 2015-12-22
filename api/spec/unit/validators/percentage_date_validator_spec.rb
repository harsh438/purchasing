describe PercentageDateValidator do
  before(:all) do
    class Validatable
      include ActiveModel::Validations

      attr_accessor  :field

      validates :field, percentage_date: true
    end
  end

  let(:subject) { Validatable.new }

  after(:all) { Object.send(:remove_const, :Validatable) }

  describe 'Date' do
    it 'accepts valid dates' do
      subject.field = { percentage: 10, date: '2010-01-01' }
      expect(subject.valid?).to be(true)
    end

    it 'rejects invalid dates' do
      subject.field = { percentage: 10, date: 'not_a_date' }
      expect(subject.valid?).to be(false)
    end
  end

  describe 'Percentage' do
    it 'accepts valid percentages' do
      subject.field = { percentage: 10, date: '2010-01-01' }
      expect(subject.valid?).to be(true)
    end

    it 'rejects invalid percentages' do
      subject.field = { percentage: 'fdfsdf', date: '2010-01-01' }
      expect(subject.valid?).to be(false)
    end
  end
end
