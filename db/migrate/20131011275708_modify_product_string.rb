# coding: UTF-8
class ModifyProductBody < ActiveRecord::Migration
  def change
    remove_column :product_infos, :title
    remove_column :product_infos, :body
    remove_column :product_infos, :address
    remove_column :product_infos, :state
    remove_column :product_infos, :city
    add_column :product_infos, :title, :text, :limit => nil
    add_column :product_infos, :body, :text, :limit => nil
    add_column :product_infos, :address, :text, :limit => nil
    add_column :product_infos, :state, :text, :limit => nil
    add_column :product_infos, :city, :text, :limit => nil
  end
end
