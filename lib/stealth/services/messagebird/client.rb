# frozen_string_literal: true

require 'messagebird'

require 'stealth/services/messagebird/message_handler'
require 'stealth/services/messagebird/reply_handler'
require 'stealth/services/messagebird/setup'

module Stealth
  module Services
    module Messagebird

      class Client < Stealth::Services::BaseClient

        attr_reader :messagebird_client, :reply

        # def initialize(reply:)
        #   @reply = reply
        #   account_sid = Stealth.config.twilio.account_sid
        #   auth_token = Stealth.config.twilio.auth_token
        #   @twilio_client = ::Twilio::REST::Client.new(account_sid, auth_token)
        # end

        def initialize(reply:)
          @reply = reply
          access_key = Stealth.config.messagebird.access_key
          @messagebird_client = MessageBird::Client.new(access_key)
          @messagebird_client.enable_feature(
            MessageBird::Client::CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE
          )
        end

        # def transmit
        #   # Don't transmit anything for delays
        #   return true if reply.blank?

        #   response = twilio_client.messages.create(reply)
        #   Stealth::Logger.l(topic: "twilio", message: "Transmitting. Response: #{response.status}: #{response.error_message}")
        # end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?
          response = messagebird_client.message_create(reply)

          Stealth::Logger.l(
            topic: "messagebird",
            message:
              "Transmitting. Response: #{response.status}: " \
                "#{response.error_message}"
          )
        end

      end

    end
  end
end
