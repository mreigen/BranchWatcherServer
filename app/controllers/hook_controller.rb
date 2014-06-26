class HookController < ApplicationController
  skip_before_action :verify_authenticity_token

  # TODO: move to controller concern
  # or move to Subscriber model
  def get_subscribers
    subscriber_data = RunrWatcherServer.runr_session_get("subscribers")
    return [] unless subscriber_data.present?
    list = subscriber_data[:subscribers]["list"]
    return [] unless list.present?
    JSON.parse list
  end

  def update
    get_subscribers.each do |s|
      RunrWatcherServer.runr_send_request(
        sent_to: s,
        topic: "branch",
        task: "update",
        params: params
      )
    end
    render json: {something: "here"}
  end
end