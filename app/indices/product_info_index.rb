ThinkingSphinx::Index.define :product_info, :with => :active_record do
  indexes [title, body], as: :title_body
  index price, as: :price
  has price, post_date
end