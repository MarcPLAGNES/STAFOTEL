class Contact < ApplicationRecord
  belongs_to :user, optional: true # Optional pour les contacts créés avant connexion
  has_many :quotes
  has_many :applications
  has_many :appointments

  validates :firstname, :lastname, :email, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :user_id }
  validates :phone, format: { with: /\A[0-9\s\+\-\.\(\)]+\z/, message: "doit être un numéro valide" }

  # Normalisation
  before_save :normalize_phone

  private

  def normalize_phone
    self.phone = phone.gsub(/[^0-9+]/, '') if phone.present?
  end
end
