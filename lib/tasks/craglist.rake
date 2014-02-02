# coding: UTF-8
require 'open-uri'
DAY_RANGE = 5
task :download_data_from_craglish => :environment do
  puts 'get data form craglist'
  ERRORS = [OpenURI::HTTPError]
  RATE = 0.0174532925
  citys = [{state: 'Missouri', city: 'kansas city'}, {state: 'Iowa', city: 'iowa city'}, {state: 'Iowa', city: 'cedar rapids'}, 
    {state: 'Iowa', city: 'des moines'}, {state: 'Iowa', city: 'dubuque'}, {state: 'Iowa', city: 'fort dodge'}, {state: 'Iowa', city: 'mason city'}, 
    {state: 'Iowa', city: 'sioux city'}, {state: 'Iowa', city: 'quad cities'}, {state: 'Iowa', city: 'ottumwa'}, {state: 'Iowa', city: 'waterloo'}]
  baseuri = '.craigslist.org/sss/'
  uris = [].push baseuri
  (1..10).to_a.each do |num|
    uris.push "#{baseuri}index#{(num*100).to_s}.html"
  end

  begin
    citys.each do |city|
      puts "processing #{city[:city]} #{city[:state]}"
      default_geo_loc = Geokit::Geocoders::GoogleGeocoder3.geocode "#{city[:city]} , #{city[:state]}"
      uris.each do |baseuri|
        uri = 'http://' + city[:city].gsub(/\s+/, '') + baseuri
        puts uri
        doc = Nokogiri::HTML(open(uri))
        doc.css('p.row').each do |link|
          if ProductInfo.where(product_id: link["data-pid"].to_i).empty?
            product_info = ProductInfo.new(title: link.css('.pl a').text, 
              uri: "http://" + city[:city].gsub(/\s+/, '') + ".craigslist.org#{link.css('a')[0]['href']}", city: city[:city], state: city[:state], 
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
                product_info.address = city[:city] + ' ' + city[:state]
              end
            end

            geo_loc = Geokit::Geocoders::GoogleGeocoder3.geocode product_info.address
            if geo_loc.lat && geo_loc.lng
              product_info.latitude = geo_loc.lat * RATE
              product_info.longitude = geo_loc.lng * RATE
            else
              if default_geo_loc.lat && default_geo_loc.lng
                puts 'using default'
                product_info.latitude = default_geo_loc.lat * RATE
                product_info.longitude = default_geo_loc.lng * RATE
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
            if product_info.post_date < DAY_RANGE.days.ago
              break
            end
            if product_info.save

              if inner_doc.css('#thumbs').size > 0
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
                image = inner_doc.css('#iwi')
                if image.size > 0
                  asset = Asset.new
                  asset.product_info_id = product_info.id
                  asset.crag_uri = image.first['src']
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
    if product_info.source == ProductInfo::CRAGLIST && product_info.post_date < DAY_RANGE.days.ago
      product_info.destroy
    end
  end
end

task :drop_product_info_table => :environment do
  ProductInfo.delete_all
end