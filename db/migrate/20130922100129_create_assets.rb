# coding: UTF-8
class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.references :product_info
      t.attachment :image
      t.string :crag_uri
      t.string :crag_thumb_uri
    end
  end
end