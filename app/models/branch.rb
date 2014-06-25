require 'runr'

class Branch
  extend Runr

  class << self

    # def add_to_subscriber_list(subscriber)
    #   runr_session_set("subscriber_list", asdf)
    # end

    def subscribe(message_hsh)
      sender = message_hsh[:sender]
      # runr_data_set_set(sender, sender)

      subscriber_list = []
      subscribers     = runr_session_get("subscribers")
      if subscribers.blank? || subscribers[:list].blank?
        subscriber_list = [sender]
      else
        subscriber_list << sender
      end
      runr_session_set("subscribers", ["list", subscriber_list])
    end

    # FIXME: remove this from a list of subscribers
    def unsubscribe(message_hsh)
      # sender = message_hsh[:sender]
      # runr_data_set_get(sender)
    end
  end
end