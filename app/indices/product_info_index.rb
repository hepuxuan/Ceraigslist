ThinkingSphinx::Index.define :product_info, :with => :active_record do
  indexes [title, body, tag_list.join(" ")], as: :title_body
  index price, as: :price
  has price, post_date
end