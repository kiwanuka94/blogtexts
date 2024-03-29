class WidgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_widget, only: %i[ edit update destroy ]
  before_action :set_flashes, only: [:index]

  # GET /widgets or /widgets.json
  def index
    @widgets = current_user.widgets
  end

  # GET /widgets/new
  def new
    if !current_user.paying_customer? && current_user.widgets.count >= 3
      redirect_to subscribe_index_path, alert: "You need a pro plan for more than 3 widgets"
    else
      @widget = current_user.widgets.new
    end
  end

  # GET /widgets/1/edit
  def edit
  end

  # POST /widgets
  def create
    @widget = current_user.widgets.new(widget_params)

    respond_to do |format|
      if @widget.save
        format.html { redirect_to widgets_path, notice: "Widget was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /widgets/1
  def update
    respond_to do |format|
      if @widget.update(widget_params)
        format.html { redirect_to widget_url(@widget), notice: "Widget was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1 or /widgets/1.json
  def destroy
    @widget.destroy

    respond_to do |format|
      format.html { redirect_to widgets_path, notice: "Widget was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_widget
      @widget = current_user.widgets.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def widget_params
      params.require(:widget).permit(:name, :welcome_message, :background_color, :shape, :location, :avatar, :enabled)
    end

    def set_flashes
      if params[:subscribed] == 'true'
        current_user.delay.set_stripe_subscription
        flash.now[:notice] = 'Your account is now active!'
      end
    end
end
