# coding: UTF-8
class ProductInfo < ActiveRecord::Base
  belongs_to :user
  has_many :assets
  validates_presence_of :post_date, :title, :body, :source
  attr_accessible :assets_attributes, :post_date, :title, :body, :price, :address, :user_id, :state, :city, :tag_list, :uri, :source, :product_id, :latitude, :longitude
  acts_as_taggable
  accepts_nested_attributes_for :assets
  RATE = 0.0174532925
  LOCAL = 0
  CRAGLIST = 1
  before_save do |product_info|
  	if product_info.address.present?
      geo_loc = Geokit::Geocoders::GeonamesGeocoder.geocode product_info.address
      if geo_loc.lat && geo_loc.lng
        product_info.latitude = geo_loc.lat * RATE
        product_info.longitude = geo_loc.lng * RATE
      end
    end
  end
end