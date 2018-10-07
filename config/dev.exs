use Mix.Config

config :ecpay,
  merchant_id: {:system, "MERCHANT_ID"},
  hash_key: {:system, "HASH_KEY"},
  hash_iv:  {:system, "HASH_IV"},
  post_url: {:system, "POST_URL"}
