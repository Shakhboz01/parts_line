class PagesController < ApplicationController
  def main_page
    # TODO After price in usd field added in tr_his, separate each variables in 2 parts, usd and uzs
    # TODO include discount when calculating a remaining balance
    @buyers = Buyer.all.select { |buyer| buyer.calculate_debt > 0 }
    @providers = Provider.all.select { |provider| provider.calculate_debt > 0 }
    @delivery_from_counterparties = DeliveryFromCounterparty.unpaid.order(created_at: :desc)
    @expenditures = Expenditure.unpaid.order(created_at: :desc)
    @sales = Sale.unpaid.order(created_at: :desc)

    unless params.dig(:q, :created_at_end_of_day_lteq)
      params[:q] ||= {}
      params[:q][:created_at_end_of_day_lteq] = DateTime.current.end_of_day
    end
    unless params.dig(:q, :created_at_gteq)
      params[:q] ||= {}
      params[:q][:created_at_gteq] = DateTime.current.beginning_of_day
    end
    @q = TransactionHistory.ransack(params[:q])
    @total_income = @q.result.where(expenditure_id: nil)
      .where(delivery_from_counterparty_id: nil).sum(:price)

    @total_expenditure = @q.result.where(sale_id: nil)
      .where(sale_from_service_id: nil)
      .where(sale_from_local_service_id: nil).sum(:price)
  end

  def define_sale_destination; end

  def shortcuts; end
end
