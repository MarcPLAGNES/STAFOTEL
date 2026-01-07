# Sécurité de l'Application STAFOTEL

## ✅ Mesures de sécurité implémentées

### 1. **Authentification & Autorisation**

#### Authentification
- ✅ Devise pour la gestion sécurisée des utilisateurs
- ✅ Mots de passe hashés avec bcrypt
- ✅ Sessions sécurisées

#### Autorisation
- ✅ `authenticate_user!` sur toutes les ressources privées
- ✅ Vérification de propriété des ressources (quotes, applications, appointments)
- ✅ Les utilisateurs ne peuvent voir/modifier QUE leurs propres données
- ✅ Redirection avec message d'erreur en cas d'accès non autorisé

### 2. **Protection contre les attaques**

#### CSRF (Cross-Site Request Forgery)
- ✅ `protect_from_forgery with: :exception` activé globalement
- ✅ Tokens CSRF dans tous les formulaires Rails

#### XSS (Cross-Site Scripting)
- ✅ Échappement automatique des variables ERB
- ✅ Header `X-XSS-Protection: 1; mode=block`
- ✅ Header `X-Content-Type-Options: nosniff`

#### Clickjacking
- ✅ Header `X-Frame-Options: SAMEORIGIN`

#### SQL Injection
- ✅ Utilisation d'Active Record (requêtes paramétrées)
- ✅ Strong Parameters sur tous les contrôleurs

### 3. **Validation des données**

#### Modèle Contact
```ruby
- Email: format validé avec regex URI::MailTo::EMAIL_REGEXP
- Email: unique par utilisateur
- Téléphone: format validé, normalisé avant sauvegarde
- Tous les champs: présence obligatoire
```

#### Contrôleurs
```ruby
- Strong Parameters: seuls les champs autorisés sont acceptés
- Statuts: whitelist des valeurs autorisées
- Dates: validation que la date est dans le futur
- Gestion des erreurs ActiveRecord::RecordNotFound
```

### 4. **Protection des données (RGPD)**

#### Conformité
- ✅ Page de politique de confidentialité (`/privacy`)
- ✅ Information sur la collecte et l'utilisation des données
- ✅ Droits des utilisateurs clairement indiqués
- ✅ Lien visible dans le footer et les formulaires

#### Données personnelles
- ✅ Relation User ↔ Contact établie
- ✅ Isolation des données par utilisateur
- ✅ Email unique par utilisateur
- ✅ Téléphone normalisé (suppression caractères spéciaux)

### 5. **Relations sécurisées**

```ruby
User
  ↓ has_many
Contact
  ↓ has_many
  ├─ Quotes
  ├─ Applications
  └─ Appointments
```

Chaque ressource est liée à un Contact, lui-même lié à un User.
Les before_action vérifient la chaîne complète.

### 6. **Sécurité des sessions**

- ✅ Cookies httponly (par défaut Rails)
- ✅ Cookies samesite (protection CSRF)
- ✅ Expiration automatique des sessions

## ⚠️ Recommandations supplémentaires

### À implémenter en production

1. **HTTPS obligatoire**
```ruby
# config/environments/production.rb
config.force_ssl = true
```

2. **Rate Limiting** (protection anti-spam)
```ruby
# Gemfile
gem 'rack-attack'

# config/initializers/rack_attack.rb
Rack::Attack.throttle('req/ip', limit: 300, period: 5.minutes) do |req|
  req.ip
end
```

3. **Chiffrement des données sensibles**
```ruby
# Gemfile
gem 'attr_encrypted'

# app/models/contact.rb
attr_encrypted :phone, key: ENV['ENCRYPTION_KEY']
```

4. **Audit logs**
```ruby
gem 'paper_trail'
```

5. **CSP (Content Security Policy)**
```ruby
# config/initializers/content_security_policy.rb
# Déjà présent, à configurer selon vos CDN
```

6. **Variables d'environnement**
```bash
# Utiliser dotenv-rails pour les secrets
gem 'dotenv-rails'
```

7. **Backups réguliers**
- Base de données quotidiens
- Rétention 30 jours minimum

8. **Monitoring**
```ruby
gem 'rollbar' # ou Sentry
gem 'scout_apm' # monitoring performance
```

9. **Headers de sécurité avancés**
```ruby
# config/application.rb
config.action_dispatch.default_headers.merge!({
  'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
  'Permissions-Policy' => 'geolocation=(), microphone=(), camera=()'
})
```

10. **Tests de sécurité**
```bash
gem 'brakeman' # Analyse statique de sécurité
bundle exec brakeman
```

## 🔐 Checklist de déploiement

- [ ] HTTPS activé (Let's Encrypt)
- [ ] `force_ssl = true` en production
- [ ] Variables d'environnement sécurisées (secrets.yml.enc)
- [ ] Rate limiting activé
- [ ] Logs configurés (rotation, rétention)
- [ ] Backups automatiques configurés
- [ ] Monitoring d'erreurs activé
- [ ] Mises à jour de sécurité régulières (`bundle update`)
- [ ] Scan Brakeman passé sans erreur
- [ ] Politique de mots de passe forte (Devise)
- [ ] Email de confirmation activé (Devise)
- [ ] 2FA pour les comptes admin (optionnel)

## 📝 Maintenance

### Mises à jour régulières
```bash
bundle outdated
bundle update --conservative
```

### Scan de vulnérabilités
```bash
gem install bundler-audit
bundle audit check --update
```

### Tests de sécurité
```bash
bundle exec brakeman -A -q
```

## 👤 Contact Sécurité

Pour signaler une vulnérabilité : security@stafotel.fr

---

**Dernière révision :** 07/01/2026
**Niveau de sécurité actuel :** 🟡 Bon (avec implémentations recommandées : 🟢 Excellent)
