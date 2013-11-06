# coding: UTF-8
class User < ActiveRecord::Base
  attr_accessible :name, :email,:password, :password_confirmation, :address, :state, :city
  has_many :product_info
  has_secure_password

  before_save{|user| user.email = user.email.downcase} 
  #validates_presence_of :name, :address, :state, :city
  validates :password, presence: true, length: {minimum: 6, maximum: 120}, on: :create
  validates :password, length: {minimum: 6, maximum: 120}, on: :update, allow_blank: true

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates:email, presence: true, format:{with: VALID_EMAIL_REGEX}, uniqueness:{case_sensitive:false}
end
