require "sucker_punch"
require "trackets/client"

module Trackets
  class NoticeJob

    include SuckerPunch::Job

    def perform(exception, env, additional_info)
      Client.notify(exception, env, additional_info)
    end

  end
end
