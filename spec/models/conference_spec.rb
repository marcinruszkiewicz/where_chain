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
  end

  context 'wrong values' do
    context '.gt' do
      it 'does not accept array values' do
        expect{ Conference.where.gt(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'does not accept a string' do
        expect{ Conference.where.gt(number: 'foobar') }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'accepts integers' do 
        expect{ Conference.where.gt(number: 1) }.not_to raise_error
      end

      it 'accepts floats' do
        expect{ Conference.where.gt(number: 1.5) }.not_to raise_error
      end
    end

    context '.gte' do
      it 'does not accept array values' do
        expect{ Conference.where.gte(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'does not accept a string' do
        expect{ Conference.where.gte(number: 'foobar') }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'accepts integers' do 
        expect{ Conference.where.gte(number: 1) }.not_to raise_error
      end

      it 'accepts floats' do
        expect{ Conference.where.gte(number: 1.5) }.not_to raise_error
      end
    end

    context '.lt' do
      it 'does not accept array values' do
        expect{ Conference.where.lt(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'does not accept a string' do
        expect{ Conference.where.lt(number: 'foobar') }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'accepts integers' do 
        expect{ Conference.where.lt(number: 1) }.not_to raise_error
      end

      it 'accepts floats' do
        expect{ Conference.where.lt(number: 1.5) }.not_to raise_error
      end
    end

    context '.lte' do
      it 'does not accept array values' do
        expect{ Conference.where.lte(number: [1, 2, 3]) }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'does not accept a string' do
        expect{ Conference.where.lte(number: 'foobar') }.to raise_error ArgumentError, 'The value passed to this method should be a number'
      end

      it 'accepts integers' do 
        expect{ Conference.where.lte(number: 1) }.not_to raise_error
      end

      it 'accepts floats' do
        expect{ Conference.where.lte(number: 1.5) }.not_to raise_error
      end
    end
  end
end
