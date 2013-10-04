# coding: UTF-8
class CreateCategorys < ActiveRecord::Migration
  def change
    create_table :category do |t|
      t.string :name
    end
  end
end