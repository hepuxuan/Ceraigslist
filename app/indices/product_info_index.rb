ThinkingSphinx::Index.define :product_info, with: :active_record do
  indexes [title, body, address, state, city, tag_list.join], as: :title_body
  index price, as: :price
  has processed
  has price, post_date
  has latitude, longitude
end