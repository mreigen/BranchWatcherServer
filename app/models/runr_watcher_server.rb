require 'runr'

class RunrWatcherServer
  extend Runr

  runr_authorized_tasks  :subscribe, :unsubscribe
  runr_authorized_topics :branch, :repo

  TOPIC_MAP = {
    'branch' => Branch,
    'repo'   => Repo
  }

  TASK_MAP = {
    'subscribe'   => 'subscribe',
    'unsubscribe' => 'unsubscribe'
  }

  class << self

    # @param [Hash] message_hsh The hash that comprises the Runr message
    #   received by the CMS app
    #
    # Routes Runr messages.
    # Returns an error if the message is invalid in any way.
    # Otherwise, calls a class method in the appropriate model
    # and either sends an error or a callback, or delegates follow-up
    # to the class method called depending on the return value of the class method.
    #
    # @example
    #   RunrWatcherServer.runr_command({ topic: 'content', task: 'delete', params: { id: '123456' } }) #=> (deletes the ContentItem with ID '123456')
    def runr_command(message_hsh, context_hsh = {})
      warn "received request: #{message_hsh}"

      send_to = message_hsh[:reply_to] ? message_hsh[:reply_to] : message_hsh[:sent_to]

      # check the topic value is in the TOPIC_MAP and maps to a class
      if TOPIC_MAP[message_hsh[:topic]].is_a?(Class)
        # use the topic value to route to the appropriate class
        data_with_results = TOPIC_MAP[message_hsh[:topic]].send(TASK_MAP[message_hsh[:task]], message_hsh)
      else
        # call the method in the action field of the data hash directly
        data_with_results = self.send(message_hsh[:task], message_hsh)
      end

      generic_response_data = {
        sender: channel_name,
        sent_to: send_to,
        timestamp: Time.now
      }

      if data_with_results.is_a?(Hash) && data_with_results.key?(:error)
        # return an error message to the sender
        response = message_hsh.merge(generic_response_data).
          merge(data_with_results).
          merge({
            data: {}
          })
        runr_send_error(response)
      elsif data_with_results
        # send a callback containing the data returned
        response = message_hsh.merge(generic_response_data).
          merge({
            data: data_with_results
          })
        runr_send_callback(response)
      else
        # Do nothing if results were nil (Runr follow-up delegated to model)
        return true
      end
    end

    def runr_callback(message_hsh, context_hsh)
      warn "received callback: #{message_hsh}"
    end

    def runr_feedback(message_hsh, context_hsh)
      warn "received feedback: #{message_hsh}"
    end

    def runr_error(message_hsh, context_hsh)
      warn "received error: #{message_hsh}"
    end

    def runr_ack(message_hsh, context_hsh = {})
      warn "received ack: #{message_hsh}"
    end

  end

  start_listening

end
