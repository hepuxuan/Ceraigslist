# coding: UTF-8
class ModifyProductid < ActiveRecord::Migration
  def change
    remove_column :product_infos, :product_id
    add_column :product_infos, :product_id, :integer, :limit => 8
  end
end