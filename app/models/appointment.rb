class Appointment < ApplicationRecord
  belongs_to :contact
  belongs_to :quote
end
