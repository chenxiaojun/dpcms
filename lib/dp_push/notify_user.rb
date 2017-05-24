module DpPush
  class NotifyUser
    def initialize(user, msg)
      @push = DpPush::Push.new
      @user = user
      @msg = msg
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      @push.push(push_payload)
    end

    def push_payload
      @push.payload(
        platform: 'all',
        audience: audience,
        notification: notification
      ).set_options(options)
    end

    def options
      # True 表示推送生产环境，False 表示要推送开发环境
      { apns_production: ENV['JPUSH_APNS_PRODUCTION'] }
    end

    def audience
      jpush_alias = "#{ENV['CURRENT_PROJECT_ENV']}_#{@user.user_uuid}"
      @push.audience.set_alias(jpush_alias)
    end

    def notification
      @push.notification.set_alert(@msg)
    end
  end
end