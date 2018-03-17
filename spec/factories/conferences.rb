FactoryBot.define do
  factory :conference do
    number 5
    name "Wroclove.rb"
    date DateTime.new(2018, 3, 18)

    trait :other_conference do 
      number 10
      name 'Something else'
      date DateTime.new(2017, 3, 18)
    end
  end
end
