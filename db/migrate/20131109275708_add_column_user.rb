# coding: UTF-8
class AddColumnUser < ActiveRecord::Migration
  def change
    add_column :users, :longitude, 'double precision'
    add_column :users, :latitude, 'double precision'
  end
end
