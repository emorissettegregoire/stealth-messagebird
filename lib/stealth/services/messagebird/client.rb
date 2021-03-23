# frozen_string_literal: true
require 'pry'
require 'json'

require 'messagebird'

require 'stealth/services/messagebird/message_handler'
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
          # @messagebird_client.enable_feature(
          #   MessageBird::Client::CONVERSATIONS_WHATSAPP_SANDBOX_FEATURE
          # )

          # if api_key.present?
          #   @twilio_client = ::Twilio::REST::Client.new(
          #     api_key, auth_token, account_sid
          #   )
          # else
          #   @twilio_client = ::Twilio::REST::Client.new(account_sid, auth_token)
          # end
        end

        def transmit
          # Don't transmit anything for delays
          return true if reply.blank?

          response = messagebird_client.send_conversation_message(reply[:from], reply[:to], reply)
          # Reply to a conversation
          # response = messagebird_client.conversation_reply("1bdccc16cb724a379c167f67b600156d", reply)
          # EXAMPLE OF ERROR MESSAGES IN TWILIO - NEED TO ADJUST FOR MESSAGEBIRD
          # begin
          #   response = twilio_client.messages.create(reply)
          # rescue ::Twilio::REST::RestError => e
          #   case e.message
          #   when /21610/ # Attempt to send to unsubscribed recipient
          #     raise Stealth::Errors::UserOptOut
          #   when /21612/ # 'To' phone number is not currently reachable via SMS
          #     raise Stealth::Errors::UserOptOut
          #   when /21614/ # 'To' number is not a valid mobile number
          #     raise Stealth::Errors::UserOptOut
          #   when /30004/ # Message blocked
          #     raise Stealth::Errors::UserOptOut
          #   when /21211/ # Invalid 'To' Phone Number
          #     raise Stealth::Errors::InvalidSessionID
          #   when /30003/ # Unreachable destination handset
          #     raise Stealth::Errors::InvalidSessionID
          #   when /30005/ # Unknown destination handset
          #     raise Stealth::Errors::InvalidSessionID
          #   else
          #     raise
          #   end
          # end

          Stealth::Logger.l(
            topic: "messagebird",
            message:
              "Transmitting. Response: #{response.status}: " \
                # "#{response.errors}"
          )
        end
      end
    end
  end
end
