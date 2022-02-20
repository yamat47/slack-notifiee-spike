module SlackNotifiee
  def enable
    storage_path = Pathname('tmp/slack-notifiee')

    _reset_storage(storage_path)
    _override_http_client(storage_path)
  end

  def _reset_storage(path)
    ::FileUtils.mkdir_p(path)
    ::FileUtils.rm_f(path.children)
  end

  def _override_http_client(path)
    ::Slack::Notifier.class_eval { prepend SlackNotifierExtension }
  end

  module_function :enable, :_reset_storage, :_override_http_client
  private_class_method :_reset_storage, :_override_http_client

  module HttpClient
    def post(uri, params)
      payload = JSON.parse(params[:payload])
      notification_content = payload.merge(uri: uri, datetime: Time.now.iso8601(6))

      filepath = Pathname(Pathname('tmp/slack-notifiee')) + "#{ULID.generate}.json"
      File.open(filepath, 'w') { |file| JSON.dump(notification_content, file) }
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
