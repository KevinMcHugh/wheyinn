class Event < ActiveRecord::Base
  default_scope { order(created_at: :asc) }

  has_many :checkins
  has_many :people, through: :checkins
end
