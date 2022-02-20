# frozen_string_literal: true

require 'slack-notifier'
require 'dotenv/load'
require 'pathname'
require 'fileutils'
require 'ulid'
require 'time'

require_relative './slack_notifiee'

SlackNotifiee.enable

webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
notifier = Slack::Notifier.new(webhook_url)

text = "Danny Torrence left a 1 star review for your property."
block = [
  {
    "type": "section",
    "text": {
      "type": "mrkdwn",
      "text": "Danny Torrence left the following review for your property:"
    }
  },
  {
    "type": "section",
    "block_id": "section567",
    "text": {
      "type": "mrkdwn",
      "text": "<https://example.com|Overlook Hotel> \n :star: \n Doors had too many axe holes, guest in room 237 was far too rowdy, whole place felt stuck in the 1920s."
    },
    "accessory": {
      "type": "image",
      "image_url": "https://is5-ssl.mzstatic.com/image/thumb/Purple3/v4/d3/72/5c/d3725c8f-c642-5d69-1904-aa36e4297885/source/256x256bb.jpg",
      "alt_text": "Haunted hotel image"
    }
  },
  {
    "type": "section",
    "block_id": "section789",
    "fields": [
      {
        "type": "mrkdwn",
        "text": "*Average Rating*\n1.0"
      }
    ]
  }
]

100.times { notifier.post text: text, blocks: block }
