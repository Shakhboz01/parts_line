class TransactionHistoriesController < ApplicationController
  before_action :set_transaction_history, only: %i[ show edit update destroy ]

  # GET /transaction_histories or /transaction_histories.json
  def index
    @q = TransactionHistory.ransack(params[:q])
    @transaction_histories = @q.result.order(id: :desc)
    @transaction_histories =
      @transaction_histories.where(sale_id: params[:sale_id])
                            .where(expenditure_id: params[:expenditure_id])
                            .where(delivery_from_counterparty_id: params[:delivery_from_counterparty_id])
    @transaction_histories_data = @transaction_histories
    @transaction_histories = @transaction_histories.page(params[:page]).per(40)
  end

  # GET /transaction_histories/1 or /transaction_histories/1.json
  def show
  end

  # GET /transaction_histories/new
  def new
    @transaction_history = TransactionHistory.new
  end

  # GET /transaction_histories/1/edit
  def edit
  end

  # POST /transaction_histories or /transaction_histories.json
  def create
    @transaction_history = TransactionHistory.new(transaction_history_params)
    @transaction_history.user_id = current_user.id
    respond_to do |format|
      if @transaction_history.save
        format.html { redirect_to request.referrer, notice: "Transaction history was successfully created." }
        format.json { render :show, status: :created, location: @transaction_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_histories/1 or /transaction_histories/1.json
  def update
    respond_to do |format|
      if @transaction_history.update(transaction_history_params)
        format.html { redirect_to request.referrer, notice: "Transaction history was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_histories/1 or /transaction_histories/1.json
  def destroy
    @transaction_history.destroy

    respond_to do |format|
      format.html { redirect_to request.referrer, notice: "Transaction history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction_history
    @transaction_history = TransactionHistory.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_history_params
    params.require(:transaction_history).permit(:sale_id, :sale_from_service_id, :sale_from_local_service_id, :delivery_from_counterparty_id, :expenditure_id, :price)
  end
end
