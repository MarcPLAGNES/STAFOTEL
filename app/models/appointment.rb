class Appointment < ApplicationRecord
  belongs_to :contact
  belongs_to :quote, optional: true
end
