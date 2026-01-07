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
end
