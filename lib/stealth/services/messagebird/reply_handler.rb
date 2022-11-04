# frozen_string_literal: true
module Stealth
  module Services
    module Messagebird
      class ReplyHandler < Stealth::Services::BaseReplyHandler

        attr_reader :recipient_id, :reply

        def initialize(recipient_id: nil, reply: nil)
          @recipient_id = recipient_id
          @reply = reply
        end

        def text
          check_text_length

          translated_reply = reply['text']

          suggestions = generate_suggestions(suggestions: reply['suggestions'])
          buttons = generate_buttons(buttons: reply['buttons'])

          if suggestions.present?
            translated_reply = [
              translated_reply,
              I18n.t(
                "stealth.messagebird.respond_with_a_number",
                default: "Respond with a number:"
              )
            ].join("\n\n")

            suggestions.each_with_index do |suggestion, i|
              translated_reply = [
                translated_reply,
                I18n.t(
                  "stealth.messagebird.number_option",
                  number: i + 1,
                  suggestion: suggestion,
                  default: "%{number} for %{suggestion}"
                )
              ].join("\n")
            end
          end

          if buttons.present?
            buttons.each do |button|
              translated_reply = [
                translated_reply,
                button
              ].join("\n\n")
            end
          end

          format_response(type: 'text', content: { text: translated_reply })
        end

        def image
          check_text_length
          format_response(type: 'image', content: { image: { caption: reply['text'], url: reply['image_url'] } })
        end

        def audio
          check_text_length

          format_response(type: 'audio', content: { audio: { caption: reply['text'], url: reply['audio_url'] } })
        end

        def video
          check_text_length

          format_response(type: 'video', content: { video: { caption: reply['text'], url: reply['video_url'] } })
        end

        def file
          check_text_length

          format_response(type: 'file', content: { file: { caption: reply['text'], url: reply['file_url'] } })
        end

        def location
          check_text_length

          format_response(type: 'location', content: { location: { latitude: reply['latitude'], longitude: reply['longitude'] } })
        end

        def sticker
          check_text_length

          format_response(type: 'whatsappSticker', content: { whatsappSticker: { link: reply['sticker_url'] } })
        end

        def quick_reply
          check_text_length

          reply['type'].present? ? template_with_header : template
        end

        def template_with_header
          format_response(
            type: 'interactive',
            content: {
              interactive: {
                type: 'button',
                header: {
                  type: reply['type'],
                  "#{reply['type']}": {
                    url: reply['url']
                  }
                },
                body: {
                  text: reply['text']
                },
                action: {
                  buttons:
                    generate_quick_replies(buttons: reply['buttons'])
                }
              }
            }
          )
        end

        def template
          format_response(
            type: 'interactive',
            content: {
              interactive: {
                type: 'button',
                body: {
                  text: reply['text']
                },
                action: {
                  buttons:
                    generate_quick_replies(buttons: reply['buttons'])
                }
              }
            }
          )
        end

        def list
          check_text_length

          format_response(
            type: 'interactive',
            content: {
              interactive: {
                type: 'list',
                header: {
                  type: 'text',
                  text: reply['title']
                },
                body: {
                  text: reply['text']
                },
                action: {
                  button: reply['button'],
                  sections: generate_sections(sections: reply['sections'])
                }
              }
            }
          )
        end

        def delay

        end

        private

        def check_text_length
          if reply['text'].present? && reply['text'].size > 1600
            raise(ArgumentError, "Text messages must be 1600 characters or less.")
          end
        end

        def format_response(response)
          sender_info = {
            from: Stealth.config.messagebird.channel_id.to_s,
            to: recipient_id.to_s
          }
          response.merge(sender_info)
        end

        def generate_suggestions(suggestions:)
          return if suggestions.blank?

          mf = suggestions.collect do |suggestion|
            suggestion['text']
          end.compact
        end

        def generate_buttons(buttons:)
          return if buttons.blank?

          sms_buttons = buttons.map do |button|
            case button['type']
            when 'url'
              "#{button['text']}: #{button['url']}"
            when 'payload'
              I18n.t(
                "stealth.messagebird.text_option",
                text: button['text'],
                option: button['payload'],
                default: "For %{text}: Text %{option}"
              )
            when 'call'
              "#{button['text']}: #{button['phone_number']}"
            end
          end.compact

          sms_buttons
        end

        def generate_quick_replies(buttons:)
          if buttons.size > 3
            raise(ArgumentError, "WhatsApp quick reply message supports up to 3 buttons. Use WhatsApp list instead.")
          end

          buttons.map do |button|
            if button['title'].size > 20
              raise(ArgumentError, "A button has a maximum of 20 characters.")
            end

            {
              id: button['payload'],
              type: 'reply',
              title: button['title']
            }
          end
        end

        def generate_sections(sections:)
          check_number_of_list_buttons(sections)

          sections.map do |section|
            {
              title: section['title'],
              rows: generate_list_of_buttons(buttons: section['buttons'])
            }
          end
        end

        def generate_list_of_buttons(buttons:)
          buttons.map do |button|
            check_list_button_field_length(button: button['title'])
            description = button['description'].present? ? button['description'] : nil

            {
              id: button['payload'],
              title: button['title'],
              description: description
            }
          end
        end

        def check_list_button_field_length(button:)
          if button.size > 20
            raise(ArgumentError, "Your button '#{button}' has a maximum of 20 characters.")
          end
        end

        def check_number_of_list_buttons(sections)
          buttons = sections.map do |section|
            section["buttons"].size
          end

          total_buttons = buttons.sum

          if total_buttons > 10
            raise(ArgumentError, "WhatsApp list message supports up to 10 buttons.")
          end
        end
      end
    end
  end
end
