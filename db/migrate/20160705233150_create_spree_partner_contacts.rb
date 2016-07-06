class CreateSpreePartnerContacts < ActiveRecord::Migration
  def change
    create_table :spree_partner_contacts do |t|
      t.string :email
      t.references :taxon

      t.timestamps null: false
    end
  end
end
