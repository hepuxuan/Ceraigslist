# coding: UTF-8
require 'open-uri'
task :download_data_from_craglish => :environment do
  puts 'get data form kasascity craglist'
  ERRORS = [OpenURI::HTTPError]
  citys = ['kansas city', 'iowa city']
  baseuri = '.craigslist.org/sss/'
  #uri = 'http://' + city + baseuri
  uris = [].push baseuri
  (1..50).to_a.each do |num|
    uris.push "#{baseuri}index#{(num*100).to_s}.html"
  end

  begin
    citys.each do |city|
      uris.each do |baseuri|
        uri = 'http://' + city.gsub(/\s+/, '') + baseuri
        doc = Nokogiri::HTML(open(uri))
        doc.css('p.row').each do |link|
          if ProductInfo.where(product_id: link["data-pid"].to_i).empty?
            product_info = ProductInfo.new(title: link.css('.pl a').text, 
              uri: "http://" + city.gsub(/\s+/, '') + ".craigslist.org#{link.css('a')[0]['href']}", city: city,
              source: ProductInfo::CRAGLIST, product_id: link["data-pid"], processed: false)

            price_text = link.css('span.price')[0]

            product_info.price = price_text ? price_text.text.delete('$').to_i : 0
            product_info.tag_list = (link.css('.l2 .gc').text.split '-').first
            inner_doc = Nokogiri::HTML(open(product_info.uri))

            product_info.body = inner_doc.css('#postingbody').text
            if inner_doc.css('.blurbs li').first
              address = inner_doc.css('.blurbs li').first.text
              address.slice!('Location: ')
              address.slice!('it\'s NOT ok to contact this poster with services or other commercial interests')
              if address.present?
                product_info.address = address
              else
                product_info.address = city
              end
            end
            
            product_info.post_date = DateTime.now
            inner_doc.css('.postinginfo').each do |post|
              post_text = post.text
              if post_text.include?('Posted:')
                post_text.slice!('Posted:')
                product_info.post_date = DateTime.parse(post_text)
              end
            end
            if product_info.post_date < 30.days.ago
              break
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
              else
                if inner_doc.css('#ci')
                  asset = Asset.new
                  asset.product_info_id = product_info.id
                  asset.crag_uri = thumb['href']
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
    end
  rescue *ERRORS => e
    puts e.to_s
    puts 'Http failure'
  end
end

task :send_email_alert => :environment do
  MILE_TO_M = 1609.344
  RATE = 0.0174532925
  User.all.each do |user|
    product_infos = []
    user.email_alerts.each do |email_alert|
      price_min = (email_alert.price_min ? email_alert.price_min : 0).to_f;
      price_max = (email_alert.price_max ? email_alert.price_max : 1000000000).to_f;
      if email_alert.distance
        distance = user.distance.to_f * MILE_TO_M
        new_product_infos = ProductInfo.search email_alert.search, :geo => [user.latitude * RATE, user.longitude * RATE], :with => {:geodist => 0.0..distance, price: price_min..price_max, processed: false}
        new_product_infos.each do |product_info|
          product_infos.push product_info
        end
      else
        new_product_infos = ProductInfo.search email_alert.search, :with => {price: price_min..price_max, processed: false}
        new_product_infos.each do |product_info|
          product_infos.push product_info
        end
      end
    end
    if !product_infos.empty?
      UserMailer.alert_email(user, product_infos).deliver
    end
  end
  ProductInfo.where(processed: false).each do |product_info|
    product_info.update_attributes(processed: true)
  end
end

task :mark_processed_true => :environment do
  ProductInfo.all.each do |product_info|
    product_info.processed = true
    product_info.save
  end
end

task :clean_product_info_table => :environment do
  ProductInfo.all.each do |product_info|
    if product_info.source == ProductInfo::CRAGLIST && product_info.post_date < 5.days.ago
      product_info.destroy
    end
  end
end

task :drop_product_info_table => :environment do
  ProductInfo.delete_all
end