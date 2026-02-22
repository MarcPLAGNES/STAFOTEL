namespace :regression do
  desc "Vérifie le flux devis avec contact existant et envoi d'email"
  task quote_flow: :environment do
    service = Service.first || Service.create!(name: "Service test", description: "Desc")
    email = "quote-regression@example.com"

    contact = Contact.where(user: nil).where("LOWER(TRIM(email)) = ?", email).first
    contact ||= Contact.create!(
      firstname: "Initial",
      lastname: "Contact",
      email: email,
      phone: "0600000000",
      user: nil
    )

    contact.assign_attributes(firstname: "Updated", lastname: "Contact", phone: "0700000000")
    unless contact.save
      abort("[FAIL] Contact update failed: #{contact.errors.full_messages.to_sentence}")
    end

    quote = Quote.new(contact: contact, service: service, status: "pending", message: "Demande test")
    unless quote.save
      abort("[FAIL] Quote save failed: #{quote.errors.full_messages.to_sentence}")
    end

    begin
      QuoteSubmissionMailer.with(quote: quote).new_quote.deliver_now
    rescue StandardError => e
      abort("[FAIL] Mail delivery failed: #{e.class} - #{e.message}")
    end

    puts "[OK] Quote flow regression check passed (quote_id=#{quote.id}, contact_id=#{contact.id})"
  end
end
