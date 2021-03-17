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
          binding.pry
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
          # response = messagebird_client.send_conversation_message(reply[:from], reply[:to], reply[:body])
          # messagebird_client.start_conversation(reply[:to], reply[:from])
          # response = messagebird_client.send_conversation_message("d5756b9c208f4e32a6a4232b54affcb4", "+261326897912", type: 'text', content: { text: 'Hello!' })
          response = messagebird_client.send_conversation_message(reply[:from], reply[:to], reply[:body])
          # response = messagebird_client.send_conversation_message(reply[:from], reply[:to], type: 'text', content: {text: 'yo testing'})

          # channel_id = '619747f69cf940a98fb443140ce9aed2'
          # to = '927832329'
          # client = MessageBird::Client.new('YOUR_ACCESS_KEY')
          # message = client.send_conversation_message(channel_id, to, type: 'text', content: { text: 'Hello!' })

          # response = messagebird_client.message_create(reply[:from], reply[:to], reply[:body])
          # response = messagebird_client.messages.create(reply)

          # Reply to a conversation
          # response = messagebird_client.conversation_reply(reply)

          Stealth::Logger.l(
            topic: "messagebird",
            message:
              "Transmitting. Response: #{response.recipients["items"]}: " \
                # "#{response.errors}"
          )
        end
      end
    end
  end
end
