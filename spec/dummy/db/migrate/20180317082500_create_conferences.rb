class CreateConferences < ActiveRecord::Migration[5.1]
  def change
    create_table :conferences do |t|
      t.integer :number
      t.string :name
      t.datetime :date

      t.timestamps
    end
  end
end
