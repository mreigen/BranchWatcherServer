require 'runr'

class Repo
  extend Runr
  class << self
    def subscribe(message_hsh)
      # branch_name = message_hsh[:params][:branch_name]
      # runr_data_set_set(branch_name, branch_name)
    end

    def unsubscribe(message_hsh)
      # branch_name = message_hsh[:params][:branch_name]
      # runr_data_set_get(branch_name)
    end
  end
end