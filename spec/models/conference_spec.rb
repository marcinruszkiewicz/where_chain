describe Conference do
  let!(:first) { create :conference }
  let!(:second) { create :conference, :other_conference }

  context 'vanilla searches' do
    it 'where' do
      expect(Conference.where(number: 5)).to match_array [first]
    end

    it '.not' do
      expect(Conference.where.not(number: 5)).to match_array [second]
    end

    it 'chains multiple times' do
      expect(Conference.where.not(number: 2).where.like(name: "Wroc%").where.not.unlike(name: "%love%")).to match_array [first]
    end
  end

  context 'LIKE' do
    it '.like' do
      expect(Conference.where.like(name: "Wroc%")).to match_array [first]
    end

    it '.unlike' do
      expect(Conference.where.unlike(name: "Wroc%")).to match_array [second]
    end

    it 'not_like' do
      expect(Conference.where.not_like(name: "Wroc%")).to match_array [second]
    end

    it '.not.like' do
      expect(Conference.where.not.like(name: "Wroc%")).to match_array [second]
    end

    it '.not.unlike' do
      expect(Conference.where.not.unlike(name: "Wroc%")).to match_array [first]
    end
  end

  context 'GREATER THAN' do
    it '.gt' do
      expect(Conference.where.gt(number: 5)).to match_array [second]
    end

    it '.gte' do
      expect(Conference.where.gte(number: 5)).to match_array [first, second]
    end

    it '.not.gt' do
      expect(Conference.where.not.gt(number: 5)).to match_array [first]
    end

    it '.gt compares dates' do
      expect(Conference.where.gt(date: DateTime.new(2017, 3, 18))).to match_array [first]
    end

    it '.gte compares dates' do
      expect(Conference.where.gte(date: DateTime.new(2017, 3, 18))).to match_array [first, second]
    end

    it '.gt compares strings' do
      expect(Conference.where.gt(name: 'Something else')).to match_array [first]
    end

    it '.gte compares strings' do
      expect(Conference.where.gte(name: 'Something else')).to match_array [first, second]
    end

    it '.gt can be used with multiple fields' do
      expect(Conference.where.gt({ date: DateTime.new(2017, 3, 18), number: 1})).to match_array [first]
    end

    it '.gte can be used with multiple fields' do
      expect(Conference.where.gte({ date: DateTime.new(2017, 3, 18), number: 1})).to match_array [first, second]
    end
  end

  context 'LESS THAN' do
    it '.lt' do
      expect(Conference.where.lt(number: 10)).to match_array [first]
    end

    it '.lte' do
      expect(Conference.where.lte(number: 10)).to match_array [first, second]
    end

    it '.not.lt' do
      expect(Conference.where.not.lt(number: 10)).to match_array [second]
    end

    it '.lt compares dates' do
      expect(Conference.where.lt(date: DateTime.new(2018, 3, 18))).to match_array [second]
    end

    it '.lte compares dates' do
      expect(Conference.where.lte(date: DateTime.new(2018, 3, 18))).to match_array [first, second]
    end

    it '.lt compares strings' do
      expect(Conference.where.lt(name: 'Wroclove.rb')).to match_array [second]
    end

    it '.lte compares strings' do
      expect(Conference.where.lte(name: 'Wroclove.rb')).to match_array [first, second]
    end

    it '.lt can be used with multiple fields' do
      expect(Conference.where.lt({ date: DateTime.new(2018, 3, 18), number: 20})).to match_array [second]
    end

    it '.lte can be used with multiple fields' do
      expect(Conference.where.lte({ date: DateTime.new(2018, 3, 18), number: 10})).to match_array [first, second]
    end
  end

  context 'wrong values' do
    context '.gt' do
      it 'does not accept array values' do
        expect{ Conference.where.gt(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept hash values' do
        expect{ Conference.where.gt(number: { bigger: :better }) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept strings' do
        expect{ Conference.where.gt('number > ?', 5) }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end

      it 'does not accept arrays' do
        expect{ Conference.where.gt([{number: 5}, 'name > ?'], 'abc') }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end
    end

    context '.gte' do
      it 'does not accept array values' do
        expect{ Conference.where.gte(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept hash values' do
        expect{ Conference.where.gte(number: { bigger: :better }) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept strings' do
        expect{ Conference.where.gte('number >= ?', 5) }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end

      it 'does not accept arrays' do
        expect{ Conference.where.gte([{number: 5}, 'name >= ?'], 'abc') }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end
    end

    context '.lt' do
      it 'does not accept array values' do
        expect{ Conference.where.lt(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept hash values' do
        expect{ Conference.where.lt(number: { bigger: :better }) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept strings' do
        expect{ Conference.where.lt('number < ?', 5) }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end

      it 'does not accept arrays' do
        expect{ Conference.where.lt([{number: 5}, 'name < ?'], 'abc') }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end
    end

    context '.lte' do
      it 'does not accept array values' do
        expect{ Conference.where.lte(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept hash values' do
        expect{ Conference.where.lte(number: { bigger: :better }) }.to raise_error ArgumentError, 'The value passed to this method should be a valid type.'
      end

      it 'does not accept strings' do
        expect{ Conference.where.lte('number <= ?', 5) }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end

      it 'does not accept arrays' do
        expect{ Conference.where.lte([{number: 5}, 'name <= ?'], 'abc') }.to raise_error ArgumentError, 'This method requires a Hash as an argument.'
      end
    end
  end
end
