class Quote < ApplicationRecord
  belongs_to :contact
  belongs_to :service
  has_many :appointments
end
