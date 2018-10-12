defmodule Ecpay.PaymentClient do
  use HTTPoison.Base
  alias Ecpay.Config
  alias __MODULE__

  def gen_check_mac_value(params) do
    params
    |> add_base_params()
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
  end

  defp pascal_params(params) do
    result = for {key, val} <- params, into: %{}, do: {Macro.camelize(Atom.to_string(key)), val}
    merchant_id = Map.get(result, "MerchantId")
    return_url = Map.get(result, "ReturnUrl")

    result
    |> Map.drop(["MerchantId", "ReturnUrl"])
    |> Map.put("MerchantID", merchant_id)
    |> Map.put("ReturnURL", return_url)
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
end
