defmodule Humaans.Telemetry do
  @moduledoc """
  Telemetry integration for the Humaans client.

  This library emits [`:telemetry`](https://hexdocs.pm/telemetry) events for
  every API request made through `Humaans.Client`. Attach handlers to observe
  latency, status codes, and errors without modifying library code.

  ## Events

  ### `[:humaans, :request, :start]`

  Emitted immediately before the HTTP request is sent.

  **Measurements:**

  | Key              | Type    | Description                             |
  |------------------|---------|-----------------------------------------|
  | `:system_time`   | integer | Current system time (native time units) |
  | `:monotonic_time`| integer | Monotonic time at request start         |

  **Metadata:**

  | Key       | Type   | Description                           |
  |-----------|--------|---------------------------------------|
  | `:method` | atom   | HTTP method (`:get`, `:post`, etc.)   |
  | `:path`   | string | API path (e.g. `"/people"`)           |
  | `:url`    | string | Full request URL                      |

  ### `[:humaans, :request, :stop]`

  Emitted after a response is received (including error responses).

  **Measurements:**

  | Key              | Type    | Description                              |
  |------------------|---------|------------------------------------------|
  | `:duration`      | integer | Request duration in native time units    |
  | `:monotonic_time`| integer | Monotonic time at request completion     |

  **Metadata:**

  | Key       | Type    | Description                                   |
  |-----------|---------|-----------------------------------------------|
  | `:method` | atom    | HTTP method                                   |
  | `:path`   | string  | API path                                      |
  | `:url`    | string  | Full request URL                              |
  | `:status` | integer | HTTP status code (present on successful HTTP) |
  | `:error`  | boolean | `true` if the HTTP client returned an error   |

  ### `[:humaans, :request, :exception]`

  Emitted if an exception is raised during the request.

  **Measurements:**

  | Key              | Type    | Description                                      |
  |------------------|---------|--------------------------------------------------|
  | `:duration`      | integer | Time elapsed before exception (native time units)|
  | `:monotonic_time`| integer | Monotonic time at exception                      |

  **Metadata:**

  | Key           | Type | Description                              |
  |---------------|------|------------------------------------------|
  | `:method`     | atom | HTTP method                              |
  | `:path`       | string | API path                               |
  | `:url`        | string | Full request URL                       |
  | `:kind`       | atom | Exception kind (`:error`, `:exit`, etc.)|
  | `:reason`     | any  | The exception or reason                  |
  | `:stacktrace` | list | Exception stacktrace                     |

  ## Usage

  Attach handlers using `:telemetry.attach/4` or `:telemetry.attach_many/4`:

      # Log all completed API requests
      :telemetry.attach(
        "humaans-logger",
        [:humaans, :request, :stop],
        fn _event, measurements, metadata, _config ->
          duration_ms =
            System.convert_time_unit(measurements.duration, :native, :millisecond)

          Logger.info(
            "Humaans API \#{metadata.method} \#{metadata.path} " <>
              "-> \#{metadata[:status]} (\#{duration_ms}ms)"
          )
        end,
        nil
      )

      # Track API errors in your monitoring system
      :telemetry.attach(
        "humaans-error-tracker",
        [:humaans, :request, :stop],
        fn _event, _measurements, %{error: true} = metadata, _config ->
          MyMonitoring.increment("humaans.api.error",
            tags: ["path:\#{metadata.path}"]
          )
        end,
        nil
      )

  """
end
