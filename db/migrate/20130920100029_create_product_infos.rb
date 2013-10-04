# coding: UTF-8
class CreateProductInfos < ActiveRecord::Migration
  def change
    create_table :product_infos do |t|
      t.references :user
      t.integer :product_id
      t.datetime :post_date
      t.string :title
      t.string :body
      t.integer :price
      t.string :address
      t.string :state
      t.string :city
      t.references :category
      t.integer :source
    end
  end
end
