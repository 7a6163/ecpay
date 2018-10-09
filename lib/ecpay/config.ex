defmodule Ecpay.Config do

  def merchant_id, do: from_env(:ecpay, :merchant_id)
  def return_url, do: from_env(:ecpay, :return_url)
  def hash_key, do: from_env(:ecpay, :hash_key)
  def hash_iv, do: from_env(:ecpay, :hash_iv)
  def encrypt_type, do: from_env(:ecpay, :encrypt_type, 1)
  def payment_type, do: from_env(:ecpay, :payment_type, "aio")

  @spec from_env(atom(), atom(), any()) :: any()
  def from_env(otp_app, key, default \\ nil)

  def from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end
