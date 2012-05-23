class Person < ActiveRecord::Base
  attr_accessible :avatar, :city, :gamername, :meetup_id, :meetup_url, :name, :state

  require 'carrierwave/orm/activerecord'

  mount_uploader :avatar, AvatarUploader

end
