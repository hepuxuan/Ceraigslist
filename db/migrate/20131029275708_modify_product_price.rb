# coding: UTF-8
class ModifyProductPrice < ActiveRecord::Migration
  def change
    remove_column :product_infos, :price
    add_column :product_infos, :price, 'double precision'
  end
end
