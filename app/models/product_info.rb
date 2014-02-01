# coding: UTF-8
class ProductInfo < ActiveRecord::Base
  belongs_to :user
  has_many :assets
  validates_presence_of :post_date, :title, :body, :source
  attr_accessible :assets_attributes, :post_date, :title, :body, :price, :address, :user_id, :state, :city, :tag_list, :uri, :source, :product_id, :latitude, :longitude, :processed
  acts_as_taggable
  accepts_nested_attributes_for :assets
  RATE = 0.0174532925
  LOCAL = 0
  CRAGLIST = 1
  before_save do |product_info|
  	if product_info.address.present? && (!product_info.longitude) && (!product_info.latitude)
      begin
        geo_loc = Geokit::Geocoders::GoogleGeocoder3.geocode product_info.address
        if geo_loc.lat && geo_loc.lng
          product_info.latitude = geo_loc.lat * RATE
          product_info.longitude = geo_loc.lng * RATE
        else
          geo_loc = Geokit::Geocoders::GoogleGeocoder3.geocode product_info.city + ' , ' + product_info.state
          if geo_loc.lat && geo_loc.lng
            product_info.latitude = geo_loc.lat * RATE
            product_info.longitude = geo_loc.lng * RATE
          end
        end
      rescue Exception => exc
        puts exc.message
      end
    end
  end
end