# Copyright 2018 OpenCensus Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This is a simple Sinatra application demonstrating how to record traces
# using OpenCensus.
#
# It uses the OpenCensus Rack middleware to trace all incoming requests. It
# also demonstrates how to use the Faraday middleware to trace outgoing HTTP
# requests, as well as how to instrument your code to capture custom spans.
#
# By default, the resulting trace data is logged in JSON format. You can also
# configure OpenCensus to report traces to a backend such as Stackdriver or
# Zipkin using an exporter plugin library.

require "sinatra"

# Install the Rack middleware to trace incoming requests.
require "opencensus/trace/integrations/rack_middleware"

# Register callback for set attribute in span

def put_user_id_to_attribute span, env
  span.put_attribute "user_id", env["HTTP_X_USER_ID"]
end

LONG_TASK_DURATION_KEY = "LONG_TASK_DURATION_KEY".freeze

def put_long_task_duration_to_attribute span, env
  span.put_attribute "long_task_duration", env[LONG_TASK_DURATION_KEY]
end

use OpenCensus::Trace::Integrations::RackMiddleware,
    on_start_span: ->(span, env) { put_user_id_to_attribute span, env },
    on_finish_span: lambda do |span, env|
      put_long_task_duration_to_attribute span, env
    end

# Access the Faraday middleware which will be used to trace outgoing HTTP
# requests.
require "opencensus/trace/integrations/faraday_middleware"

# Each request will be traced automatically by the middleware.
get "/" do
  "Hello world!"
end

# Traces for this request will also include sub-spans as indicated below.
get "/lengthy" do
  # Configure this Faraday connection with a middleware to trace outgoing
  # requests.
  conn = Faraday.new(url: "http://www.google.com") do |c|
    c.use OpenCensus::Trace::Integrations::FaradayMiddleware
    c.adapter Faraday.default_adapter
  end
  conn.get "/"

  # You may instrument your code to create custom spans for long-running
  # operations.
  OpenCensus::Trace.in_span "long task" do
    t = rand
    sleep t
    request.env[LONG_TASK_DURATION_KEY] = t
  end

  "Done!"
end
