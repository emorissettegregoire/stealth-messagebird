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
          if params.dig('message', 'origin') == 'inbound'
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
          service_message.messagebird_id = params['contact']['id']
          service_message.display_name = params['contact']['displayName']
          service_message.first_name = params['contact']['firstName']
          service_message.last_name = params['contact']['lastName']
          service_message.platform = params['message']['platform']

          if params['message']['type'] == 'image'
            service_message.attachments = [{
              type: params['message']['type'],
              url: params['message']['content']['image']['url']
            }]
          elsif params['message']['type'] == 'video'
            service_message.attachments = [{
              type: params['message']['type'],
              url: params['message']['content']['video']['url']
            }]
          elsif params['message']['type'] == 'audio'
            service_message.attachments = [{
              type: params['message']['type'],
              url: params['message']['content']['audio']['url']
            }]
          elsif params['message']['type'] == 'file'
            service_message.attachments = [{
              type: params['message']['type'],
              location: params['message']['content']['file']['url']
            }]
          elsif params['message']['type'] == 'location'
            service_message.location = [{
              type: params['message']['type'],
              location: params['message']['content']['location']
            }]
          end

          service_message
        end
      end
    end
  end
end
