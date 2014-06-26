require 'runr'

class Branch
  extend Runr

  class << self

    # TODO: Decide if the server or the client will do the logic of
    # comparing branch/repo names. If the server will send out all
    # the updates from github then the client will sort them out (more flexible). Or
    # if the server will filter them out then only send to some clients

    # TODO move this subscrition methods to Subscriber model??

    def subscribe(message_hsh)
      sender = message_hsh[:sender]

      subscriber_list = []
      subscribers     = RunrWatcherServer.runr_session_get("subscribers")

      if subscribers && subscribers[:subscribers] && subscribers[:subscribers]["list"]
        subscriber_list = JSON.parse subscribers[:subscribers]["list"]
        subscriber_list << sender
      else
        subscriber_list = [sender]
      end
      RunrWatcherServer.runr_session_set("subscribers", ["list", subscriber_list])
    end

    # FIXME: remove this from a list of subscribers
    def unsubscribe(message_hsh)
      # sender = message_hsh[:sender]
      # runr_data_set_get(sender)
    end
  end
end