# Copyright 2017 OpenCensus Authors
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

require "opencensus"

module OpenCensus
  module Trace
    module Integrations
      ##
      # # Rack integration
      #
      # This is a middleware for Rack applications:
      #
      # * It wraps all incoming requests in a root span
      # * It exports the captured spans at the end of the request.
      #
      # Example:
      #
      #     require "opencensus/trace/integrations/rack_middleware"
      #
      #     use OpenCensus::Trace::Integrations::RackMiddleware
      #
      class RackMiddleware
        ##
        # List of trace context formatters we use to parse the parent span
        # context.
        #
        # @private
        #
        AUTODETECTABLE_FORMATTERS = [
          Formatters::CloudTrace.new,
          Formatters::TraceContext.new
        ].freeze

        OpenCensus::Trace.configure do |c|
          c.add_config! :rack do |rc|
            rc.add_option! :on_start_span, nil
            rc.add_option! :on_finish_span, nil
          end
        end

        ##
        # Create the Rack middleware.
        #
        # @param [#call] app Next item on the middleware stack
        # @param [#export] exporter The exported used to export captured spans
        #     at the end of the request. Optional: If omitted, uses the exporter
        #     in the current config.
        # @param [Proc] on_start_span A callback evaluated after span created
        # @param [Proc] on_finish_span A callback evaluated after span finished
        #
        def initialize \
            app,
            exporter: nil,
            on_start_span: nil,
            on_finish_span: nil
          @app = app
          @exporter = exporter || OpenCensus::Trace.config.exporter
          @on_start_span = on_start_span
          @on_finish_span = on_finish_span

          # rubocop:disable Metrics/LineLength

          @on_start_span = OpenCensus::Trace.configure.rack.on_start_span if @on_start_span.nil?
          @on_finish_span = OpenCensus::Trace.configure.rack.on_finish_span if @on_finish_span.nil?

          # rubocop:enable Metrics/LineLength
        end

        ##
        # Run the Rack middleware.
        #
        # @param [Hash] env The rack environment
        # @return [Array] The rack response. An array with 3 elements: the HTTP
        #     response code, a Hash of the response headers, and the response
        #     body which must respond to `each`.
        #
        def call env # rubocop:disable Metrics/MethodLength
          formatter = AUTODETECTABLE_FORMATTERS.detect do |f|
            env.key? f.rack_header_name
          end
          if formatter
            context = formatter.deserialize env[formatter.rack_header_name]
          end

          Trace.start_request_trace \
            trace_context: context,
            same_process_as_parent: false do |span_context|
            begin
              Trace.in_span get_path(env) do |span|
                @on_start_span.call(span, env) if @on_start_span
                start_request span, env
                @app.call(env).tap do |response|
                  finish_request span, response
                  @on_finish_span.call(span, env) if @on_finish_span
                end
              end
            ensure
              @exporter.export span_context.build_contained_spans
            end
          end
        end

        private

        def get_path env
          path = "#{env['SCRIPT_NAME']}#{env['PATH_INFO']}"
          path = "/#{path}" unless path.start_with? "/"
          path
        end

        def get_host env
          env["HTTP_HOST"] || env["SERVER_NAME"]
        end

        def get_url env
          path = get_path env
          host = get_host env
          scheme = env["SERVER_PROTOCOL"]
          query_string = env["QUERY_STRING"].to_s
          url = "#{scheme}://#{host}#{path}"
          url = "#{url}?#{query_string}" unless query_string.empty?
          url
        end

        def start_request span, env
          span.kind = SpanBuilder::SERVER
          span.put_attribute "http.host", get_host(env)
          span.put_attribute "http.method", env["REQUEST_METHOD"]
          span.put_attribute "http.path", get_path(env)
          span.put_attribute "http.url", get_url(env)
          span.put_attribute "http.client_protocol", env["SERVER_PROTOCOL"]
          span.put_attribute "http.user_agent", env["HTTP_USER_AGENT"]
          span.put_attribute "pid", ::Process.pid.to_s
          span.put_attribute "tid", ::Thread.current.object_id.to_s
        end

        def finish_request span, response
          if response.is_a?(::Array) && response.size == 3
            span.set_status \
              OpenCensus::Trace::Status.convert_code_from_http response[0]
          end
        end
      end
    end
  end
end
