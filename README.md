# Messagebird WhatsApp Driver for Stealth

The [Stealth](https://github.com/hellostealth/stealth) WhatsApp driver adds the ability to build your bot using [Messagebird](https://www.messagebird.com/en/solutions/whatsapp-api) service.

Messagebird allow you to use your [own mobile number](https://support.messagebird.com/hc/en-us/articles/360000244558-How-to-pick-a-number-for-WhatsApp-Business) for WhatsApp. So no geographic restrictions compare to virtual mobile numbers (VMNs).

In `Gemfile`
```
gem 'stealth-messagebird'
```

Then create a Messagebird account and install your [WhatsApp Business channel](https://support.messagebird.com/hc/en-us/articles/360000258437-WhatsApp-Business-step-by-step-onboarding). This gem is not supporting the Messagebird Sandbox, since their Sandbox has limitations.

## WhatsApp Supported Reply Types

* Text

* Image

* Audio

* Video/GIF (receive only)

* File

* Sticker

In your Stealth bot replies
```
- reply_type: sticker
  sticker_url: "https://your-sticker.webp"
```

* Delay

* Location

In your Stealth bot replies
```
- reply_type: location
  latitude: 41.69352000000001
  longitude: 44.801473999999985
```

* Quick Reply (max 3 buttons)

In your Stealth bot replies
```
- reply_type: quick_reply
  header_type: "image"
  header_url: "https://image.png"
  text: "Your text"
  buttons:
    - title: "button 1"
      payload: "button-1"
    - title: "button 2"
      payload: "button-2"
    - title: "button 3"
      payload: "button-3"

- reply_type: quick_reply
  header_type: "text"
  header_text: "Awesome text"
  text: "More descriptive text"
  buttons:
    - title: "button 1"
      payload: "button-1"
    - title: "button 2"
      payload: "button-2"
    - title: "button 3"
      payload: "button-3"
```

`header_type` can be an "image", "video", "document" or "text".
User's input can be retrieved in `current_message.payload`

* List message (max 10 buttons)

In your Stealth bot replies
```
- reply_type: list
  title: "What would you like to buy today?"
  text: "To begin, tap Main Menu and choose from one of the following options."
  button: "Main Menu"
  sections:
    - title: "Bundles"
      buttons:
        - title: "Buy bundle 1"
          payload: "bundle-1"
        - title: "Buy bundle 2"
          payload: "bundle-2"
    - title: "Airtime"
      buttons:
        - title: "Buy Airtime"
          payload: "airtime-1"
          description: "optional description"
```
User's input can be retrieved in `current_message.payload`

More info here: https://developers.messagebird.com/quickstarts/whatsapp-deepdive/

## Configure Messagebird with your Stealth bot
Once your WhatsApp Business Channel is active, you will receive a `channel_id`.
To visualize your channel_id, go to `Channels` in the sidebar of your Messagebird Dashboard.
You will need your Live API Key as well, go to `Developers` in the sidebar of your Messagebird Dashboard.

In `services.yml`
```
messagebird:
    access_key: <%= ENV['MESSAGEBIRD_ACCESS_KEY'] %>
    channel_id: <%= ENV['MESSAGEBIRD_CHANNEL_ID'] %>
```

## Setup your Webhook
Create your webhook so that Messagebird can communicate with your app when receiving a message from a user.
Subscribe to `message.created` event only.

```
curl -X POST "https://conversations.messagebird.com/v1/webhooks/" \
  -H "Authorization: AccessKey YOUR_ACCESS_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "events": ["message.created"],
    "channelId": "YOUR_CHANNEL_ID",
    "url": "https://1cfd8wc098r0.ngrok.io/incoming/messagebird"
  }'
```
When you provide your local ngrok URL to a messaging service, you will have to add /incoming/messagebird. More infos on [Stealth Repo](https://github.com/hellostealth/stealth/wiki/Local-Development).

For more infos on webhooks, follow the [Messagebird instructions](https://developers.messagebird.com/api/conversations/#create-webhook).

## current_message
When calling the `current_message` method in your Stealth bot, you can retrieve the following informations:
```
#<Stealth::Services::Messagebird::MessagebirdServiceMessage:0x00009ceg7cef4cd3
@attachments=[],
@conversation_id="1cdeee16bd432a987c167f67b611056f",
@display_name="Emilie",
@first_name="",
@last_name="",
@location={},
@message="Yo",
@messagebird_id="9881a12f6hhe4g41b9935hh4d299c01f",
@platform="whatsapp",
@read={},
@sender_id="33320110909",
@service="messagebird",
@target_id="098882ge-b745-1f12-a02f-4c1239da7d01",
@timestamp="2021-04-13T12:23:16Z">
```
