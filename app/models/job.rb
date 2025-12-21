class Job < ApplicationRecord
  has_many :applications

  validates :title, :description, presence: true
end
