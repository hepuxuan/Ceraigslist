# coding: UTF-8
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :password_digest
      t.string :address
      t.string :state
      t.string :city
    end
  end
end