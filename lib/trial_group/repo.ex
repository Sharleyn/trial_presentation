defmodule TrialGroup.Repo do
  use Ecto.Repo,
    otp_app: :trial_group,
    adapter: Ecto.Adapters.Postgres
end
