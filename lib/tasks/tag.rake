task :count_tags => :environment do
  ProductInfo.tag_counts.order('tags_count DESC').each do |tag|
    puts "#{tag.name}:#{tag.count.to_s}"
  end
end