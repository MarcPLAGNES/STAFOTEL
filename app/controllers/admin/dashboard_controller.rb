module Admin
  class DashboardController < BaseController
    TEST_PATTERNS = ["%test%", "%fake%", "%demo%", "%example%", "%mailinator%"].freeze

    def index
      @quotes = Quote.includes(:service, :contact).order(created_at: :desc).limit(20)
      @applications = Application.includes(:job, :contact).order(created_at: :desc).limit(20)
      @contacts = Contact.order(created_at: :desc).limit(20)
      @messages = Contact.where.not(message: [nil, ""]).order(created_at: :desc).limit(20)
    end

    def clear_test_data
      test_contacts = Contact.where(
        TEST_PATTERNS.map { "LOWER(email) LIKE ?" }.join(" OR "),
        *TEST_PATTERNS
      )

      contact_ids = test_contacts.pluck(:id)

      if contact_ids.empty?
        redirect_to admin_root_path, notice: "Aucune donnée de test à supprimer."
        return
      end

      quotes_deleted = Quote.where(contact_id: contact_ids).delete_all
      applications_deleted = Application.where(contact_id: contact_ids).delete_all
      appointments_deleted = Appointment.where(contact_id: contact_ids).delete_all
      contacts_deleted = Contact.where(id: contact_ids).delete_all

      redirect_to admin_root_path, notice: "Données de test supprimées : #{contacts_deleted} contacts, #{quotes_deleted} devis, #{applications_deleted} candidatures, #{appointments_deleted} rendez-vous."
    end

    def clear_all_data
      appointments_deleted = 0
      quotes_deleted = 0
      applications_deleted = 0
      contacts_deleted = 0

      ActiveRecord::Base.transaction do
        appointments_deleted = Appointment.delete_all
        quotes_deleted = Quote.delete_all
        applications_deleted = Application.delete_all
        contacts_deleted = Contact.delete_all
      end

      redirect_to admin_root_path, notice: "Toutes les données ont été supprimées : #{contacts_deleted} contacts, #{quotes_deleted} devis, #{applications_deleted} candidatures, #{appointments_deleted} rendez-vous."
    end
  end
end
