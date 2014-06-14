require "sucker_punch"
require "trackets/client"

module Trackets
  class NoticeJob

    include SuckerPunch::Job

    def perform(exception, env)
      Client.notify(exception, env)
    end

  end
end
