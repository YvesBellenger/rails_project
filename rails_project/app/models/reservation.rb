class Reservation < ApplicationRecord
  resourcify

  belongs_to :user
  belongs_to :book
end
