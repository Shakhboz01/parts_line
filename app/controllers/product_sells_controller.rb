class ProductSellsController < ApplicationController
  before_action :set_product_sell, only: %i[ show edit update destroy ]

  # GET /product_sells or /product_sells.json
  def index
    @product_sells = ProductSell.all
  end

  # GET /product_sells/1 or /product_sells/1.json
  def show
  end

  # GET /product_sells/new
  def new
    @product_sell = ProductSell.new
  end

  # GET /product_sells/1/edit
  def edit
  end

  # POST /product_sells or /product_sells.json
  def create
    @product_sell = ProductSell.new(product_sell_params)

    respond_to do |format|
      if @product_sell.save
        format.html { redirect_to product_sell_url(@product_sell), notice: "Product sell was successfully created." }
        format.json { render :show, status: :created, location: @product_sell }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_sells/1 or /product_sells/1.json
  def update
    respond_to do |format|
      if @product_sell.update(product_sell_params)
        format.html { redirect_to product_sell_url(@product_sell), notice: "Product sell was successfully updated." }
        format.json { render :show, status: :ok, location: @product_sell }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_sells/1 or /product_sells/1.json
  def destroy
    @product_sell.destroy

    respond_to do |format|
      format.html { redirect_to product_sells_url, notice: "Product sell was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_sell
      @product_sell = ProductSell.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_sell_params
      params.require(:product_sell).permit(:combination_of_local_product_id, :product_id, :sell_price_in_usd, :sell_price_in_uzs, :buy_price_in_usd, :buy_price_in_uzs, :total_profit_in_usd, :total_profit_in_uzs, :paid_in_usd)
    end
end
