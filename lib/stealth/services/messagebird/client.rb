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

            # case e.message
            # when /301/ # Message failed to send
            #   raise Stealth::Errors::UserOptOut
            # when /302/ # Contact is not registered on WhatsApp
            #   raise Stealth::Errors::UserOptOut
            # when /470/ # Outside the support window for freeform messages
            #   raise Stealth::Errors::UserOptOut
            # when /2/ # Request not allowed
            #   raise Stealth::Errors::UserOptOut
            # when /25/ # Not enough balance
            #   raise Stealth::Errors::UserOptOut
            # else
            #   raise
            # end

          # Reply to a conversation
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
          binding.pry

          Stealth::Logger.l(
            topic: "messagebird",
            message:
              "Transmitting. Response: #{response.status}: " \
              # if response.errors.present?
              #   "#{response.errors[].description}"
              # end
          )
        end
      end
    end
  end
end
