class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_widget, only: [:create]

  def create
    if @widget.enabled?
      message = @widget.messages.create(message_params)
      message.notify_user
    end
    head :ok
  end

  def index
    @messages = current_user.messages.newest_to_oldest
    @user = current_user
    @messages_tagline = current_user.phone? ? phone_tagline : non_phone_tagline


    respond_to do |format|
      format.html { @messages }
      format.csv { send_data(Message.to_csv(@messages), filename: "messages-#{Date.today}.csv") }
    end
  end

  private

  def phone_tagline
    'Below is a list of messages you have received from your website visitors.'
  end

  def non_phone_tagline
    'Please add your phone number in account settings to receive messages.'
  end

  def set_widget
    @widget = Widget.find_by(client_id: params[:client_id])
  end

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end 


end
