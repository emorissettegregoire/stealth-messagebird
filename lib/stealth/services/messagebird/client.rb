# frozen_string_literal: true
require 'messagebird'
require 'stealth/services/messagebird/message_handler'
require 'stealth/services/messagebird/messagebird_service_message'
require 'stealth/services/messagebird/reply_handler'
require 'stealth/services/messagebird/setup'

module Stealth
  module Services
    module Messagebird
      class Client < Stealth::Services::BaseClient
        attr_reader :messagebird_client, :reply

        def initialize(reply:)
          @reply = reply
          access_key = Stealth.config.messagebird.access_key
          @messagebird_client = MessageBird::Client.new(access_key)
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?

          response = messagebird_client.send_conversation_message(reply[:from], reply[:to], reply)

          if response.status == "failed" || response.status == "rejected"
            case response.error.code
            when /301/ # Message failed to send
              raise Stealth::Errors::UserOptOut
            when /302/ # Contact is not registered on WhatsApp
              raise Stealth::Errors::UserOptOut
            when /470/ # Outside the support window for freeform messages
              raise Stealth::Errors::UserOptOut
            when /2/ # Request not allowed
              raise Stealth::Errors::UserOptOut
            when /25/ # Not enough balance
              raise Stealth::Errors::UserOptOut
            else
              raise
            end
          end

          message = "Transmitting. Response: #{response.status}: "
          if response.status == "failed" || response.status == "rejected"
            message += response.error.description
          end
          Stealth::Logger.l(topic: "messagebird", message: message)
        end
      end
    end
  end
end
