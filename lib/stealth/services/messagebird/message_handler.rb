# frozen_string_literal: true
module Stealth
  module Services
    module Messagebird
      class MessageHandler < Stealth::Services::BaseMessageHandler
        attr_reader :service_message, :params, :headers

        def initialize(params:, headers:)
          @params = params
          @headers = headers
        end

        def coordinate
          if params.dig('message', 'direction') == 'received'
            Stealth::Services::HandleMessageJob.perform_async(
              'messagebird',
              params,
              headers
            )
          end
          # Relay our acceptance
          [200, 'OK']
        end

        def process
          @service_message = MessagebirdServiceMessage.new(service: 'messagebird')
          service_message.sender_id = params['contact']['msisdn'].to_s
          service_message.target_id = params['message']['channelId']
          service_message.timestamp = params['message']['createdDatetime']
          service_message.message = params['message']['content']['text']
          service_message.conversation_id = params['message']['conversationId']
          service_message.messagebird_id = params['contact']['id']
          service_message.display_name = params['contact']['displayName']
          service_message.first_name = params['contact']['firstName']
          service_message.last_name = params['contact']['lastName']
          service_message.platform = params['message']['platform']

          message_type = params['message']['type']
          case message_type
          when 'image'
            service_message.attachments = [{
              type: message_type,
              url: params['message']['content']['image']['url']
            }]
          when 'video'
            service_message.attachments = [{
              type: message_type,
              url: params['message']['content']['video']['url']
            }]
          when 'audio'
            service_message.attachments = [{
              type: message_type,
              url: params['message']['content']['audio']['url']
            }]
          when 'file'
            service_message.attachments = [{
              type: message_type,
              location: params['message']['content']['file']['url']
            }]
          when 'whatsappSticker'
            service_message.attachments = [{
              type: message_type,
              url: params['message']['content']['whatsappSticker']['link']
            }]
          when 'location'
            service_message.location = [{
              type: message_type,
              location: params['message']['content']['location']
            }]
          when 'interactive'
            service_message.payload = params['message']['content']['interactive']['reply']['id']
          end

          service_message
        end
      end
    end
  end
end
