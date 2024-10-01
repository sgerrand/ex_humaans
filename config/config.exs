import Config

config :humaans, client: Humaans.Client.Req

if Mix.env() == :test do
  config :humaans, client: Humaans.MockClient
end
