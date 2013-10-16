# coding: UTF-8
# lib/tasks/populate.rake
#
# Rake task to populate development database with test data
# Run it with "bundle exec rake db:populate"
# See Railscast 126 and the faker website for more information
# and credited to http://www.jacoulter.com/2011/12/21/rails-using-faker-to-populate-a-development-database/
require 'nokogiri'
require 'open-uri'
task :download_data_from_craglish => :environment do
  puts 'get data form kasascity craglist'
  ERRORS = [OpenURI::HTTPError]
  baseuri = 'http://kansascity.craigslist.org/sss/index'
  uris = [].push 'http://kansascity.craigslist.org/sss/'
  (1..10).to_a.each do |num|
    uris.push "#{baseuri}#{(num*100).to_s}.html"
  end

  begin
    uris.each do |uri|
      doc = Nokogiri::HTML(open(uri))
      doc.css('p.row').each do |link|
        if ProductInfo.where(product_id: link["data-pid"].to_i).empty?
          product_info = ProductInfo.new(title: link.css('.pl a').text, 
            uri: "http://kansascity.craigslist.org#{link.css('a')[0]['href']}", 
            source: ProductInfo::CRAGLIST, product_id: link["data-pid"])
          puts "id:#{product_info.product_id}"
          product_info.price = link.css('span.price').text.delete('$').to_i
          product_info.tag_list = (link.css('.l2 .gc').text.split '-').first
          inner_doc = Nokogiri::HTML(open(product_info.uri))
          product_info.body = inner_doc.css('#postingbody').text
          if inner_doc.css('.blurbs li').first
            product_info.address = inner_doc.css('.blurbs li').first.text
          end
          product_info.address.slice!('Location: ')
          product_info.address.slice!('it\'s NOT ok to contact this poster with services or other commercial interests')
          product_info.post_date = DateTime.now
          inner_doc.css('.postinginfo').each do |post|
            if post.text.include?('Posted:')
              product_info.post_date = DateTime.parse(post.css('date').text)
            end
          end
          if product_info.save
            if inner_doc.css('#thumbs')
              inner_doc.css('#thumbs a').each do |thumb|
                asset = Asset.new
                asset.product_info_id = product_info.id
                asset.crag_uri = thumb['href']
                asset.crag_thumb_uri = thumb.css('img')[0]['src']
                unless asset.save
                  asset.errors.full_messages.each {|e| puts e}
                end
              end
            end
          else
            product_info.errors.full_messages.each {|e| puts e}
          end
        end
      end
    end
  rescue *ERRORS => e
    puts e.to_s
    puts 'Http failure'
  end
end

task :clean_product_info_table => :environment do
  ProductInfo.all.each do |product_info|
    if product_info.source == ProductInfo::CRAGLIST
      puts "delete #{product_info.product_id}"
      product_info.destroy
    end
  end
end