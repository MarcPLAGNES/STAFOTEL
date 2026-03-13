#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:-stafotel}"
LOG_LINES="${LOG_LINES:-1200}"

section() {
  printf "\n==== %s ====\n" "$1"
}

ok() {
  printf "✅ %s\n" "$1"
}

warn() {
  printf "⚠️  %s\n" "$1"
}

fail() {
  printf "❌ %s\n" "$1"
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    fail "Commande manquante: $1"
    exit 1
  fi
}

need_cmd heroku
need_cmd grep
need_cmd wc

section "Contexte"
echo "App Heroku: ${APP_NAME}"

auth_user="$(heroku auth:whoami 2>/dev/null || true)"
if [[ -z "$auth_user" ]]; then
  fail "Tu n'es pas connecté à Heroku CLI. Lance: heroku login"
  exit 1
fi
ok "Connecté Heroku: ${auth_user}"

section "Config sécurité critique"
check_var() {
  local var_name="$1"
  local value
  value="$(heroku config:get "$var_name" --app "$APP_NAME" 2>/dev/null || true)"

  if [[ -n "$value" ]]; then
    ok "$var_name défini"
  else
    warn "$var_name manquant"
  fi
}

check_var "SECRET_KEY_BASE"
check_var "RAILS_MASTER_KEY"
check_var "APP_COOKIE_DOMAIN"
check_var "CSP_REPORT_ONLY"

secret_len="$(heroku config:get SECRET_KEY_BASE --app "$APP_NAME" 2>/dev/null | wc -c | tr -d ' ')"
if [[ "${secret_len}" -gt 40 ]]; then
  ok "SECRET_KEY_BASE longueur plausible (${secret_len})"
else
  warn "SECRET_KEY_BASE trop court ou absent (${secret_len})"
fi

csp_mode="$(heroku config:get CSP_REPORT_ONLY --app "$APP_NAME" 2>/dev/null || true)"
if [[ "$csp_mode" == "false" ]]; then
  ok "CSP en mode strict (enforced)"
elif [[ "$csp_mode" == "true" ]]; then
  warn "CSP en mode report-only"
else
  warn "CSP_REPORT_ONLY non défini (vérifie la valeur par défaut dans le code)"
fi

section "Dynos"
heroku ps --app "$APP_NAME" || true

section "Signaux de logs sécurité (dernières ${LOG_LINES} lignes)"
logs_tmp="$(mktemp)"
heroku logs -n "$LOG_LINES" --app "$APP_NAME" > "$logs_tmp" 2>/dev/null || true

show_count() {
  local label="$1"
  local pattern="$2"
  local count
  count="$(grep -Eic "$pattern" "$logs_tmp" || true)"

  if [[ "$count" -gt 0 ]]; then
    warn "$label: ${count}"
  else
    ok "$label: 0"
  fi
}

show_count "Exceptions ERROR/FATAL" "ERROR|FATAL"
show_count "CSRF invalid token" "InvalidAuthenticityToken"
show_count "Rate limit rack-attack" "rack-attack|Too many requests"
show_count "Violations CSP" "\"source\":\"csp\"|violated-directive|content security policy"
show_count "401 Unauthorized" " 401 |Unauthorized"

section "Extraits utiles"
echo "-- Dernières lignes CSP/rack-attack/CSRF --"
grep -Ei '\"source\":\"csp\"|rack-attack|InvalidAuthenticityToken|violated-directive' "$logs_tmp" | tail -n 20 || true

rm -f "$logs_tmp"

section "Résultat"
echo "Audit terminé."
echo "Conseil: relance chaque semaine avec: bin/security_audit.sh ${APP_NAME}"
