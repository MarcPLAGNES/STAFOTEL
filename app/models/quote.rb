class Quote < ApplicationRecord
  belongs_to :contact
  belongs_to :service
  has_many :appointments

  validates :contact, :service, presence: true
  validates :status, :message, presence: true
end
