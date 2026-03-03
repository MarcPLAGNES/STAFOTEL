require "devise"
require "devise/orm/active_record"

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relations
  has_many :contacts, dependent: :destroy
  has_many :quotes, through: :contacts
  has_many :applications, through: :contacts
  has_many :appointments, through: :contacts

  def admin?
    configured_admin_email = Rails.application.credentials.dig(:stafotel, :admin_email) || ENV["STAFOTEL_ADMIN_EMAIL"] || "qualite@stafotel.com"
    email.to_s.strip.downcase == configured_admin_email.to_s.strip.downcase
  end
end
