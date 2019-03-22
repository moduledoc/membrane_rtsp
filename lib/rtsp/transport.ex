defmodule Membrane.Protocol.RTSP.Transport do
  @moduledoc """
  This module represents Transport contract.
  """
  use Bunch

  @type transport_ref :: {:via, Registry, {TransportRegistry, binary()}}

  @callback execute(request :: binary(), transport_ref, options :: [tuple()]) ::
              {:ok, binary()} | {:error, atom()}

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, args}
    }
  end

  @doc """
  Starts and links Transport process.

  Transport process is immediately registered in TransportRegistry via `Registry`.
  """
  @spec start_link(module(), binary(), URI.t()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(module, ref, connection_info) do
    GenServer.start_link(module, connection_info, name: transport_name(ref))
  end

  @spec transport_name(binary()) :: transport_ref
  def transport_name(ref), do: {:via, Registry, {TransportRegistry, ref}}
end
