class ApplicationController < ActionController::Base
  # Protection CSRF activée par défaut dans Rails
  protect_from_forgery with: :exception

  # Empêche le clickjacking
  before_action :set_security_headers

  private

  def set_security_headers
    response.headers['X-Frame-Options'] = 'SAMEORIGIN'
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-XSS-Protection'] = '1; mode=block'
  end
end
