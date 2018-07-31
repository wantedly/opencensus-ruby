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

module OpenCensus
  module Trace
    ##
    # The `Status` type defines a logical error model that is suitable for
    # different programming environments, including REST APIs and RPC APIs.
    # This Trace's fields are a subset of those of
    # [google.rpc.Status](https://github.com/googleapis/googleapis/blob/master/google/rpc/status.Trace),
    # which is used by [gRPC](https://github.com/grpc).
    class Status
      ##
      # Status codes for use with `Status`
      # There are defined by gRPC https://github.com/googleapis/googleapis/blob/master/google/rpc/code.proto
      OK                  = 0
      CANCELLED           = 1
      UNKNOWN             = 2
      INVALID_ARGUMENT    = 3
      DEADLINE_EXCEEDED   = 4
      NOT_FOUND           = 5
      ALREADY_EXISTS      = 6
      PERMISSION_DENIED   = 7
      RESOURCE_EXHAUSTED  = 8
      FAILED_PRECONDITION = 9
      ABORTED             = 10
      OUT_OF_RANGE        = 11
      UNIMPLEMENTED       = 12
      INTERNAL            = 13
      UNAVAILABLE         = 14
      DATA_LOSS           = 15
      UNAUTHENTICATED     = 16

      # rubocop:disable Metrics/MethodLength

      ##
      # Convert HTTP status code to gRPC defined.
      #
      # @param [Integer] http_status_code HTTP status code
      # @return [Integer] gRPC defined code
      #
      def self.convert_code_from_http http_status_code
        case http_status_code
        when 200..399
          OK
        when 400
          INVALID_ARGUMENT
        when 504
          DEADLINE_EXCEEDED
        when 404
          NOT_FOUND
        when 403
          PERMISSION_DENIED
        when 401
          UNAUTHENTICATED
        when 429
          RESOURCE_EXHAUSTED
        when 501
          UNIMPLEMENTED
        when 503
          UNAVAILABLE
        else
          UNKNOWN
        end
      end

      # rubocop:enable Metrics/MethodLength

      ##
      # The status code.
      #
      # @return [Integer]
      #
      attr_reader :code

      ##
      # A developer-facing error message, which should be in English.
      #
      # @return [String]
      #
      attr_reader :message

      ##
      # Create an empty Status object.
      #
      # @private
      #
      def initialize code, message
        @code = code
        @message = message
      end
    end
  end
end
