class ProductSellsController < ApplicationController
  before_action :set_product_sell, only: %i[ show edit update destroy ]

  # GET /product_sells or /product_sells.json
  def index
    @q = ProductSell.ransack(params[:q])
    @product_sells = @q.result.order(id: :desc).page(params[:page]).per(40)
  end

  # GET /product_sells/1 or /product_sells/1.json
  def show
  end

  # GET /product_sells/new
  def new
    @product_sell = ProductSell.new(combination_of_local_product_id: params[:combination_of_local_product_id])
  end

  # GET /product_sells/1/edit
  def edit
  end

  # POST /product_sells or /product_sells.json
  def create
    @product_sell = ProductSell.new(product_sell_params)

    respond_to do |format|
      if @product_sell.save
        if @product_sell.combination_of_local_product_id.present?
          format.html { redirect_to combination_of_local_product_url(@product_sell.combination_of_local_product), notice: "Product sell was successfully created." }
        end

        format.html { redirect_to product_sells_url, notice: "Product sell was successfully created." }
        format.json { render :show, status: :created, location: @product_sell }
      else
        format.html { render :new, product_sell: @product_sell, status: :unprocessable_entity }
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
        format.html { render :edit, product_sell: @product_sell, status: :unprocessable_entity }
        format.json { render json: @product_sell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_sells/1 or /product_sells/1.json
  def destroy
    @product_sell.destroy

    respond_to do |format|
      if @product_sell.combination_of_local_product_id.present?
        format.html { redirect_to combination_of_local_product_url(@product_sell.combination_of_local_product), notice: "Product sell was successfully destroyed." }
      end

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
    params.require(:product_sell).permit(:combination_of_local_product_id, :product_id, :total_profit, :amount, :payment_type)
  end
end
