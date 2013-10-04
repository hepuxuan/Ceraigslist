# coding: UTF-8
class AddColumnToProductInfos < ActiveRecord::Migration
  def change
    add_column :product_infos, :uri, :string
    add_index :product_infos, :product_id
  end
end