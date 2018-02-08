class CreateHoldings < ActiveRecord::Migration[5.1]
  def change
    create_table :holdings do |t|
      t.string :crypto
      t.float :amount

      t.timestamps
    end
  end
end
