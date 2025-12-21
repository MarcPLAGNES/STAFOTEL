class Contact < ApplicationRecord
  has_many :quotes
  has_many :applications
  has_many :appointments
end
