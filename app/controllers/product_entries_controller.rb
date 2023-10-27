class ProductEntriesController < ApplicationController
  before_action :set_product_entry, only: %i[ show edit update destroy ]

  # GET /product_entries or /product_entries.json
  def index
    @q = ProductEntry.ransack(params[:q])
    @product_entries = @q.result.includes(:product).order(created_at: :desc).page(params[:page]).per(40)
  end

  # GET /product_entries/1 or /product_entries/1.json
  def show
  end

  # GET /product_entries/new
  def new
    return redirect_to define_product_destination_product_entries_path if params[:local_entry].nil?

    @product_entry = ProductEntry.new(
      local_entry: params[:local_entry],
      return: params[:return]
    )
    @products = Product.active
    if params[:local_entry] == 'true'
      @products = @products.where(local: true)
    else
      @products = @products.where(local: false)
    end

    @products = @products
  end

  def define_product_destination; end

  # GET /product_entries/1/edit
  def edit
  end

  # POST /product_entries or /product_entries.json
  def create
    @product_entry = ProductEntry.new(product_entry_params)

    respond_to do |format|
      if @product_entry.save
        if @product_entry.local_entry
          format.html { redirect_to combination_of_local_product_path(CombinationOfLocalProduct.last), notice: "Пожалуйста, укажите любые расходы, которые используются для производства этого продукта." }
        else
          format.html { redirect_to product_entries_url, notice: "Product entry was successfully created." }
        end
        format.json { render :show, status: :created, location: @product_entry }
      else
        format.html { render :new, product_entry: @product_entry, status: :unprocessable_entity }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /product_entries/1 or /product_entries/1.json
  def update
    respond_to do |format|
      if @product_entry.update(product_entry_params)
        format.html { redirect_to product_entries_url, notice: "Product entry was successfully updated." }
        format.json { render :show, status: :ok, location: @product_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_entries/1 or /product_entries/1.json
  def destroy
    @product_entry.destroy

    respond_to do |format|
      format.html { redirect_to product_entries_url, notice: "Product entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_entry
      @product_entry = ProductEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_entry_params
      params.require(:product_entry).permit(:local_entry, :buy_price, :sell_price, :storage_id, :service_price, :provider_id, :product_id, :amount, :amount_sold, :total_paid, :total_price, :comment, :return)
    end
end
