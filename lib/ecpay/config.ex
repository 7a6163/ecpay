defmodule Ecpay.Config do

  def merchent_id, do: from_env(:ecpay, :merchent_id)
  def hash_key, do: from_env(:ecpay, :hash_key)
  def hash_iv, do: from_env(:ecpay, :hash_iv)

  def from_env(otp_app, key, default \\ nil)

  def from_env(otp_app, key, default) do
    otp_app
    |> Application.get_env(key, default)
    |> read_from_system(default)
  end

  defp read_from_system({:system, env}, default), do: System.get_env(env) || default
  defp read_from_system(value, _default), do: value
end