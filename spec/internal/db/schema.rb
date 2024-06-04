# frozen_string_literal: true

ActiveRecord::Schema.define do
  # Set up any tables you need to exist for your test suite that don't belong
  # in migrations.
  create_table 'conferences', force: :cascade do |t|
    t.integer 'number'
    t.string 'name'
    t.datetime 'date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
