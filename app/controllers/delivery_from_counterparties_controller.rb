class DeliveryFromCounterpartiesController < ApplicationController
  before_action :set_delivery_from_counterparty, only: %i[ show edit update destroy ]

  # GET /delivery_from_counterparties or /delivery_from_counterparties.json
  def index
    @q = DeliveryFromCounterparty.ransack(params[:q])
    @delivery_from_counterparties = @q.result.page(params[:page]).per(40)
  end

  # GET /delivery_from_counterparties/1 or /delivery_from_counterparties/1.json
  def show
    @expenditures = @delivery_from_counterparty.expenditures
    @expenditures_data = @delivery_from_counterparty.expenditures
    @q = @delivery_from_counterparty.product_entries.ransack(params[:q])
    @product_entries = @q.result
  end

  # GET /delivery_from_counterparties/new
  def new
    @delivery_from_counterparty = DeliveryFromCounterparty.new
  end

  # GET /delivery_from_counterparties/1/edit
  def edit
    if params[:status]
      @delivery_from_counterparty.status = params[:status].to_i
      @delivery_from_counterparty.total_price = @total_price
    end
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
    byebug
    respond_to do |format|
      if @delivery_from_counterparty.update(delivery_from_counterparty_params.merge(status: delivery_from_counterparty_params[:status].to_i))
        format.html { redirect_to delivery_from_counterparties_url, notice: "Delivery from counterparty was successfully updated." }
        format.json { render :show, status: :ok, location: @delivery_from_counterparty }
      else
        byebug
        format.html { redirect_to request.referrer }
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
    params.require(:delivery_from_counterparty).permit(:total_price, :status, :total_paid, :payment_type, :comment, :provider_id)
  end
end
