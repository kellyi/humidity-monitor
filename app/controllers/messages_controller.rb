class MessagesController < ApplicationController
  def index
    @remaining_messages = MessageQuota.new.remaining_messages
  end
end
