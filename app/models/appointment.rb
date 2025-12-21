class Appointment < ApplicationRecord
  belongs_to :contact
  belongs_to :quote

  validates :date, :status, :contact, :quote, presence: true
end
