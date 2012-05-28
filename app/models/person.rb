class Person < ActiveRecord::Base
  
  has_many :entrants
  has_many :events, :through => :entrants

  attr_accessible :avatar, :city, :gamername, :meetup_id, :meetup_url, :name, :state

  require 'carrierwave/orm/activerecord'
  include Tire::Model::Search
  include Tire::Model::Callbacks

  mount_uploader :avatar, AvatarUploader




end
