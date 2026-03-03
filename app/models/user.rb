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
    admin_emails = []

    credentials_admin_email = Rails.application.credentials.dig(:stafotel, :admin_email)
    admin_emails << credentials_admin_email if credentials_admin_email.present?

    env_admin_email = ENV["STAFOTEL_ADMIN_EMAIL"]
    admin_emails << env_admin_email if env_admin_email.present?

    env_admin_emails = ENV["STAFOTEL_ADMIN_EMAILS"]
    if env_admin_emails.present?
      admin_emails.concat(env_admin_emails.split(","))
    end

    admin_emails.concat(["qualite@stafotel.com", "admin@stafotel.com"])

    normalized_admin_emails = admin_emails.map { |value| value.to_s.strip.downcase }.reject(&:blank?).uniq
    normalized_admin_emails.include?(email.to_s.strip.downcase)
  end
end
