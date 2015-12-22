describe PercentageOfValidator do
  before(:all) do
    class Validatable
      include ActiveModel::Validations

      attr_accessor  :field

      validates :field, percentage_of: { of: ['valid_thing',
                                              'another_valid_thing'] }
    end
  end

  let(:subject) { Validatable.new }

  after(:all) { Object.send(:remove_const, :Validatable) }

  describe 'Options' do
    it 'accepts valid options' do
      subject.field = { percentage: 10, of: 'valid_thing' }
      expect(subject.valid?).to be(true)
    end

    it 'rejects invalid options' do
      subject.field = { percentage: 10, of: 'not_a_thing' }
      expect(subject.valid?).to be(false)
    end
  end

  describe 'Percentage' do
    it 'accepts valid percentages' do
      subject.field = { percentage: 10, of: 'valid_thing' }
      expect(subject.valid?).to be(true)
    end

    it 'rejects invalid percentages' do
      subject.field = { percentage: 'fdfsdf', of: 'valid_thing' }
      expect(subject.valid?).to be(false)
    end
  end
end
