class HookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    RunrWatcherServer.runr_send_request(
      sent_to: "watcher1",
      topic: "branch",
      task: "update",
      data: {what:"sup"}
    )
    render json: {something: "here"}
  end
end