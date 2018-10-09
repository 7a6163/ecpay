defmodule Ecpay.PaymentClient do
  use HTTPoison.Base
  alias Ecpay.Config
  alias __MODULE__

  def aio_check_out_all(params) do
    params
    |> add_base_params()
    |> pascal_params()
    |> do_post()
  end

  defp gen_check_mac_value(params) do
    params
    |> pascal_params()
    |> query_string()
    |> add_hash()
    |> encode_string()
    |> String.downcase()
    |> encrypted_by_sha256()
  end

  defp add_base_params(params) do
    params
    |> Map.put(:merchant_id, Config.merchant_id())
    |> Map.put(:return_url, Config.return_url())
    |> Map.put(:encrypt_type, Config.encrypt_type())
    |> Map.put(:payment_type, Config.payment_type())
    |> Map.put(:check_mac_value, gen_check_mac_value(params))
  end

  defp pascal_params(params) do
    for {key, val} <- params, into: %{}, do: {Macro.camelize(key), val}
  end

  defp query_string(params) do
    params |> Enum.map(fn({key, value}) -> "#{key}=#{value}" end) |> Enum.join("&")
  end

  defp add_hash(query_string) do
    "HashKey=#{Config.hash_key}&#{query_string}&HashIV=#{Config.hash_iv}"
  end

  defp encode_string(query_string) do
    URI.encode_www_form(query_string)
  end

  defp encrypted_by_sha256(query_string) do
    Base.encode16(:crypto.hash(:sha256, query_string))
  end

  defp do_post(params) do
    PaymentClient.post!("https://payment-stage.ecpay.com.tw/Cashier/AioCheckOut/V5", params)
  end
end
