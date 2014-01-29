# coding: UTF-8
class User < ActiveRecord::Base
  attr_accessible :name, :email,:password, :password_confirmation, :address, :state, :city, :longitude, :latitude, :email_alerts
  has_many :product_info
  has_many :email_alerts
  has_secure_password
  accepts_nested_attributes_for :email_alerts
  #validates_presence_of :name, :address, :state, :city
  validates :password, presence: true, length: {minimum: 6, maximum: 120}, on: :create
  validates :password, length: {minimum: 6, maximum: 120}, on: :update, allow_blank: true

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates:email, presence: true, format:{with: VALID_EMAIL_REGEX}, uniqueness:{case_sensitive:false}
  RATE = 0.0174532925
  before_save do |user|
  	user.email = user.email.downcase
  	if user.address.present?
      begin
        geo_loc = Geokit::Geocoders::GoogleGeocoder3.geocode(user.address + ', ' +user.city + ' ' + user.state)
        user.latitude = geo_loc.lat * RATE
        user.longitude = geo_loc.lng * RATE
      rescue
      end
    end
  end
end
