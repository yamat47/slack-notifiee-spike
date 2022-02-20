# frozen_string_literal: true
#
# Usage:
#   $ bundle exec ruby notify.rb

require 'slack-notifier'
require 'slack_notifiee'
require 'dotenv/load'

# SlackNotifiee.enable

webhook_url = ENV.fetch('SLACK_WEBHOOK_URL')
notifier = Slack::Notifier.new(webhook_url)

# notifier.post text: 'Hello, World!', at: 'here', channel: '#general'
# notifier.ping 'Hello, World!'
# notifier.post text: "feeling spooky", icon_emoji: ":ghost:"

# notifier.post blocks: [
#   {"type": "section", "text": {"type": "plain_text", "text": "Hello world"}},
#   {"type": "section", "text": {"type": "plain_text", "text": "Hello world"}},
#   {"type": "section", "text": {"type": "plain_text", "text": "Hello world"}},
#   {"type": "section", "text": {"type": "plain_text", "text": "Hello world"}},
# ], username: 'notify', icon_emoji: ':smile:'

notifier.post(
  username: 'Notificaion bot via slack-notify',
  channel: '#general',
  attachments: [{"pretext": "pre-hello", "text": "text-world"}],
  blocks: [{"type": "section", "text": {"type": "plain_text", "text": "Hello world"}}],
  text: 'Hello world',
  icon_emoji: ':chart_with_upwards_trend:',
  icon_url: 'https://picsum.photos/200/300'
)

# SlackNotifiee.notifications
