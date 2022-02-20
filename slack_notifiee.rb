module SlackNotifiee
  def enable
    _reset_storage
    _override_http_client
  end

  def store_notification(notification)
    filepath = _storage_path + "#{ULID.generate}.json"
    File.open(filepath, 'w') { |file| JSON.dump(notification, file) }
  end

  def _storage_path
    Pathname('tmp/slack-notifiee')
  end

  def _reset_storage
    ::FileUtils.mkdir_p(_storage_path)
    ::FileUtils.rm_f(_storage_path.children)
  end

  def _override_http_client
    ::Slack::Notifier.class_eval { prepend SlackNotifierExtension }
  end

  module_function :enable, :store_notification, :_storage_path, :_reset_storage, :_override_http_client
  private_class_method :_storage_path, :_reset_storage, :_override_http_client

  module HttpClient
    def post(uri, params)
      payload = JSON.parse(params[:payload])
      notification_content = payload.merge(uri: uri, datetime: Time.now.iso8601(6))

      SlackNotifiee.store_notification(notification_content)
    end

    module_function :post
  end

  module SlackNotifierExtension
    def initialize(webhook_url, options={}, &block)
      http_client = ::SlackNotifiee::HttpClient
      options.merge!(http_client: http_client)

      super(webhook_url, options, &block)
    end
  end
end
