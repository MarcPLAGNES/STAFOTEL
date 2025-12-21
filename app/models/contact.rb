class Contact < ApplicationRecord
  has_many :quotes
  has_many :applications
  has_many :appointments

  validates :firstname, :lastname, :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
