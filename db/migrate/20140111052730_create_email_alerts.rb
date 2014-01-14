class CreateEmailAlerts < ActiveRecord::Migration
  def change
    create_table :email_alerts do |t|
      t.references :user
      t.integer :price_min
      t.integer :price_max
      t.string :search
      t.integer :distance
      t.timestamps
    end
  end
end
