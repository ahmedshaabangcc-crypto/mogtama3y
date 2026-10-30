-- =====================================================================
-- Migration 0101 — متجري: Fawaterak API v3 (OAuth).
--
-- Fawaterak's dashboard now issues OAuth client credentials (API v2 is
-- deprecated on 1 Jan 2027). A merchant connects with:
--   * client_id (public, a UUID) + client_secret → POST /oauth/token →
--     Bearer token for createTransaction / getTransactionData;
--   * api_key (the vendor API key) → checks the webhooks'
--     transactionHashKey. Orders are settled from getTransactionData in any
--     case, never from a callback body.
-- The domain «hash key» is for Fawaterak's browser iframe only — not used.
-- An order's payment_invoice_id now holds the transaction intent_key.
-- Run after 0100. Safe to re-run.
-- =====================================================================

create or replace function private.gateway_fields(p_provider text) returns jsonb
language sql immutable as $$
  select case p_provider
    when 'fawaterak' then jsonb_build_object(
      'public', jsonb_build_object('client_id', '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'),
      'secret', jsonb_build_object(
        'client_secret', '^[A-Za-z0-9._~+/=-]{16,255}$',
        'api_key', '^[A-Za-z0-9._~+/=-]{16,255}$'),
      'required', jsonb_build_array('client_id', 'client_secret', 'api_key'))
    when 'paymob' then jsonb_build_object(
      'public', jsonb_build_object(
        'card_integration_id', '^[0-9]{3,12}$',
        'wallet_integration_id', '^[0-9]{3,12}$',
        'iframe_id', '^[0-9]{2,12}$',
        'public_key', '^[a-z]{3}_pk_(test|live)_[A-Za-z0-9]{8,120}$'),
      'secret', jsonb_build_object(
        'api_key', '^[A-Za-z0-9+/=._-]{20,}$',
        'secret_key', '^[a-z]{3}_sk_(test|live)_[A-Za-z0-9]{8,200}$',
        'hmac_secret', '^[A-Za-z0-9]{16,128}$'),
      'required', jsonb_build_array('card_integration_id', 'api_key', 'hmac_secret'))
    when 'kashier' then jsonb_build_object(
      'public', jsonb_build_object('merchant_id', '^MID-[0-9]{1,10}-[0-9]{1,10}$'),
      'secret', jsonb_build_object(
        'api_key', '^[A-Za-z0-9-]{16,100}$',
        'secret_key', '^[A-Za-z0-9$._/-]{16,200}$'),
      'required', jsonb_build_array('merchant_id', 'api_key', 'secret_key'))
    when 'tap' then jsonb_build_object(
      'public', jsonb_build_object(
        'publishable_key', '^pk_(test|live)_[A-Za-z0-9]{10,64}$',
        'merchant_id', '^[0-9]{3,20}$'),
      'secret', jsonb_build_object('secret_key', '^sk_(test|live)_[A-Za-z0-9]{10,64}$'),
      'required', jsonb_build_array('publishable_key', 'secret_key'))
    when 'moyasar' then jsonb_build_object(
      'public', jsonb_build_object('publishable_key', '^pk_(test|live)_[A-Za-z0-9]{20,64}$'),
      'secret', jsonb_build_object('secret_key', '^sk_(test|live)_[A-Za-z0-9]{20,64}$'),
      'required', jsonb_build_array('publishable_key', 'secret_key'))
    else null end
$$;

-- A Fawaterak connection saved with 0100's v2 fields (api_key only) can't
-- make v3 transactions: back to «مستني الاختبار» until the merchant adds
-- the client ID + secret.
update public.shop_payment_gateways g
   set status = 'pending', last_error = 'فواتيرك غيّرت طريقة الربط — ضيف Client ID و Client Secret والـ API Key من لوحة فواتيرك ← Integrations'
 where g.provider = 'fawaterak' and not (g.public_cfg ? 'client_id');
