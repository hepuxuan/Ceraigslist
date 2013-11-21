# coding: UTF-8
class AddColumnProductInfo < ActiveRecord::Migration
  def change
    add_column :product_infos, :longitude, 'double precision'
    add_column :product_infos, :latitude, 'double precision'
  end
end
