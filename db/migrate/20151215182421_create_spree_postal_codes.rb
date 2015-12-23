class CreateSpreePostalCodes < ActiveRecord::Migration
  def change
    create_table :spree_postal_codes do |t|
      t.string :value, null: false
      t.references :state, index: true
      t.references :country, index: true

      t.timestamps null: false
    end

    add_index :spree_postal_codes, :value
  end
end
