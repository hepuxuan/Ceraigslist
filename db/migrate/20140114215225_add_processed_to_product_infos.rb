class AddProcessedToProductInfos < ActiveRecord::Migration
  def change
    add_column :product_infos, :processed, :boolean
    add_index :product_infos, :processed
  end
end
