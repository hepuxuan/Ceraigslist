# coding: UTF-8
class ModifyProductBody < ActiveRecord::Migration
  def change
    remove_column :product_infos, :body
    add_column :product_infos, :body, :string, :limit => nil
  end
end