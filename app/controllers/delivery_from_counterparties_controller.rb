class DeliveryFromCounterpartiesController < ApplicationController
  before_action :set_delivery_from_counterparty, only: %i[ show edit update destroy ]

  # GET /delivery_from_counterparties or /delivery_from_counterparties.json
  def index
    @delivery_from_counterparties = DeliveryFromCounterparty.all
  end

  # GET /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def show
  end

  # GET /delivery_from_counterparties/new
  def new
    @delivery_from_counterparty = DeliveryFromCounterparty.new
  end

  # GET /delivery_from_counterparties/1/edit
  def edit
  end

  # POST /delivery_from_counterparties or /delivery_from_counterparties.json
  def create
    @delivery_from_counterparty = DeliveryFromCounterparty.new(delivery_from_counterparty_params)

    respond_to do |format|
      if @delivery_from_counterparty.save
        format.html { redirect_to delivery_from_counterparty_url(@delivery_from_counterparty), notice: "Delivery from counterparty was successfully created." }
        format.json { render :show, status: :created, location: @delivery_from_counterparty }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @delivery_from_counterparty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def update
    respond_to do |format|
      if @delivery_from_counterparty.update(delivery_from_counterparty_params)
        format.html { redirect_to delivery_from_counterparty_url(@delivery_from_counterparty), notice: "Delivery from counterparty was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery_from_counterparty }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @delivery_from_counterparty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def destroy
    @delivery_from_counterparty.destroy

    respond_to do |format|
      format.html { redirect_to delivery_from_counterparties_url, notice: "Delivery from counterparty was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_delivery_from_counterparty
      @delivery_from_counterparty = DeliveryFromCounterparty.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def delivery_from_counterparty_params
      params.require(:delivery_from_counterparty).permit(:total_price, :total_paid, :payment_type, :comment, :provider_id)
    end
end
