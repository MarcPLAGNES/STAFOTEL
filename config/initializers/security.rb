# config/initializers/security.rb
# Configuration de sécurité pour STAFOTEL

Rails.application.config.to_prepare do
  # Protection contre le mass assignment
  ActiveRecord::Base.class_eval do
    def self.inherited(subclass)
      super
      # Log des tentatives de mass assignment non autorisées
      subclass.class_eval do
        def log_protected_attribute_removal(*attributes)
          Rails.logger.warn "Tentative de mass assignment non autorisé: #{attributes.inspect}" if attributes.any?
        end
      end
    end
  end
end

# Configuration des sessions sécurisées
Rails.application.config.session_store :cookie_store,
  key: '_stafotel_session',
  secure: Rails.env.production?,  # Cookies HTTPS uniquement en production
  httponly: true,                  # Pas d'accès JavaScript
  same_site: :lax                  # Protection CSRF

# Expiration des sessions après 2 semaines d'inactivité
Rails.application.config.session_options = {
  expire_after: 2.weeks
}
