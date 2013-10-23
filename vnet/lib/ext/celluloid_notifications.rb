# -*- coding: utf-8 -*-
require 'celluloid'

module Celluloid::Notifications
  class Subscriber
    def publish(pattern, *args)
      actor.mailbox << { method: method, event: pattern, args: args }
    end
  end
end
