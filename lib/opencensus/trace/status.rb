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
    #
    class Status
      ##
      # Not an error; returned on success
      #
      # HTTP Mapping: 200 OK
      #
      # @return [Integer]
      #
      OK = 0

      ##
      # The operation was cancelled, typically by the caller.
      #
      # HTTP Mapping: 499 Client Closed Request
      #
      # @return [Integer]
      #
      CANCELLED = 1

      ##
      # Unknown error.  For example, this error may be returned when
      # a `Status` value received from another address space belongs to
      # an error space that is not known in this address space.  Also
      # errors raised by APIs that do not return enough error information
      # may be converted to this error.
      #
      # HTTP Mapping: 500 Internal Server Error
      #
      # @return [Integer]
      #
      UNKNOWN = 2

      ##
      # The client specified an invalid argument.  Note that this differs
      # from `FAILED_PRECONDITION`.  `INVALID_ARGUMENT` indicates arguments
      # that are problematic regardless of the state of the system
      # (e.g., a malformed file name).
      #
      # HTTP Mapping: 400 Bad Request
      #
      # @return [Integer]
      #
      INVALID_ARGUMENT = 3

      ##
      # The deadline expired before the operation could complete. For operations
      # that change the state of the system, this error may be returned
      # even if the operation has completed successfully.  For example, a
      # successful response from a server could have been delayed long
      # enough for the deadline to expire.
      #
      # HTTP Mapping: 504 Gateway Timeout
      #
      # @return [Integer]
      #
      DEADLINE_EXCEEDED = 4

      ##
      # Some requested entity (e.g., file or directory) was not found.
      #
      # Note to server developers: if a request is denied for an entire class
      # of users, such as gradual feature rollout or undocumented whitelist,
      # `NOT_FOUND` may be used. If a request is denied for some users within
      # a class of users, such as user-based access control, `PERMISSION_DENIED`
      # must be used.
      #
      # HTTP Mapping: 404 Not Found
      #
      # @return [Integer]
      #
      NOT_FOUND = 5

      ##
      # The entity that a client attempted to create (e.g., file or directory)
      # already exists.
      #
      # HTTP Mapping: 409 Conflict
      #
      # @return [Integer]
      #
      ALREADY_EXISTS = 6

      ##
      # The caller does not have permission to execute the specified
      # operation. `PERMISSION_DENIED` must not be used for rejections
      # caused by exhausting some resource (use `RESOURCE_EXHAUSTED`
      # instead for those errors). `PERMISSION_DENIED` must not be
      # used if the caller can not be identified (use `UNAUTHENTICATED`
      # instead for those errors). This error code does not imply the
      # request is valid or the requested entity exists or satisfies
      # other pre-conditions.
      #
      # HTTP Mapping: 403 Forbidden
      #
      # @return [Integer]
      #
      PERMISSION_DENIED = 7

      ##
      # Some resource has been exhausted, perhaps a per-user quota, or
      # perhaps the entire file system is out of space.
      #
      # HTTP Mapping: 429 Too Many Requests
      #
      # @return [Integer]
      #
      RESOURCE_EXHAUSTED = 8

      ##
      # The operation was rejected because the system is not in a state
      # required for the operation's execution.  For example, the directory
      # to be deleted is non-empty, an rmdir operation is applied to
      # a non-directory, etc.
      #
      # Service implementors can use the following guidelines to decide
      # between `FAILED_PRECONDITION`, `ABORTED`, and `UNAVAILABLE`:
      #   a. Use `UNAVAILABLE` if the client can retry just the failing call.
      #   b. Use `ABORTED` if the client should retry at a higher level
      #      (e.g., when a client-specified test-and-set fails, indicating the
      #      client should restart a read-modify-write sequence).
      #   c. Use `FAILED_PRECONDITION` if the client should not retry until
      #      the system state has been explicitly fixed.  E.g., if an "rmdir"
      #      fails because the directory is non-empty, `FAILED_PRECONDITION`
      #      should be returned since the client should not retry unless
      #      the files are deleted from the directory.
      #
      # HTTP Mapping: 400 Bad Request
      #
      # @return [Integer]
      #
      FAILED_PRECONDITION = 9

      ##
      # The operation was aborted, typically due to a concurrency issue such as
      # a sequencer check failure or transaction abort.
      #
      # See the guidelines above for deciding between `FAILED_PRECONDITION`,
      # `ABORTED`, and `UNAVAILABLE`.
      #
      # HTTP Mapping: 409 Conflict
      #
      # @return [Integer]
      #
      ABORTED = 10

      ##
      # The operation was attempted past the valid range.  E.g., seeking or
      # reading past end-of-file.
      #
      # Unlike `INVALID_ARGUMENT`, this error indicates a problem that may
      # be fixed if the system state changes. For example, a 32-bit file
      # system will generate `INVALID_ARGUMENT` if asked to read at an
      # offset that is not in the range [0,2^32-1], but it will generate
      # `OUT_OF_RANGE` if asked to read from an offset past the current
      # file size.
      #
      # There is a fair bit of overlap between `FAILED_PRECONDITION` and
      # `OUT_OF_RANGE`.  We recommend using `OUT_OF_RANGE` (the more specific
      # error) when it applies so that callers who are iterating through
      # a space can easily look for an `OUT_OF_RANGE` error to detect when
      # they are done.
      #
      # HTTP Mapping: 400 Bad Request
      #
      # @return [Integer]
      #
      OUT_OF_RANGE = 11

      ##
      # The operation is not implemented or is not supported/enabled in this
      # service.
      #
      # HTTP Mapping: 501 Not Implemented
      #
      # @return [Integer]
      #
      UNIMPLEMENTED = 12

      ##
      # Internal errors.  This means that some invariants expected by the
      # underlying system have been broken.  This error code is reserved
      # for serious errors.
      #
      # HTTP Mapping: 500 Internal Server Error
      #
      # @return [Integer]
      #
      INTERNAL = 13

      ##
      # The service is currently unavailable.  This is most likely a
      # transient condition, which can be corrected by retrying with
      # a backoff.
      #
      # See the guidelines above for deciding between `FAILED_PRECONDITION`,
      # `ABORTED`, and `UNAVAILABLE`.
      #
      # HTTP Mapping: 503 Service Unavailable
      #
      # @return [Integer]
      #
      UNAVAILABLE = 14

      ##
      # Unrecoverable data loss or corruption.
      #
      # HTTP Mapping: 500 Internal Server Error
      #
      # @return [Integer]
      #
      DATA_LOSS = 15

      ##
      # The request does not have valid authentication credentials for the
      # operation.
      #
      # HTTP Mapping: 401 Unauthorized
      #
      # @return [Integer]
      #
      UNAUTHENTICATED = 16

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
      # The status code. Allowed values are the Google RPC status codes
      # defined at https://github.com/googleapis/googleapis/blob/master/google/rpc/code.proto
      # and also provided as constants in this class.
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
      # Create a Status object.
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
