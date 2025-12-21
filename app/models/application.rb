class Application < ApplicationRecord
  belongs_to :contact
  belongs_to :job

  validates :contact, :job, presence: true
  validates :status, :message, presence: true
end
