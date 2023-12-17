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

    @paid_sale_in_usd = @q.result.where.not(sale_id: nil).price_in_usd.sum(:price)
    @paid_sale_in_uzs = @q.result.where.not(sale_id: nil).price_in_uzs.sum(:price)
    @total_sale_in_usd = Sale.price_in_usd
                             .where('created_at >= ?', params[:q][:created_at_gteq])
                             .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                             .sum(:total_price)
    @total_sale_in_uzs = Sale.price_in_uzs
                             .where('created_at >= ?', params[:q][:created_at_gteq])
                             .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                             .sum(:total_price)


    @total_delivery_from_counterparty_in_usd =
      DeliveryFromCounterparty.price_in_usd
                              .where('created_at >= ?', params[:q][:created_at_gteq])
                              .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                              .sum(:total_price)
    @total_delivery_from_counterparty_in_uzs =
      DeliveryFromCounterparty.price_in_uzs.where('created_at >= ?', params[:q][:created_at_gteq]).where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                              .sum(:total_price)
    @paid_delivery_from_counterparty_in_usd =
      @q.result.where.not(delivery_from_counterparty_id: nil).price_in_usd.sum(:price)
    @paid_delivery_from_counterparty_in_uzs =
      @q.result.where.not(delivery_from_counterparty_id: nil).price_in_uzs.sum(:price)


    @paid_expenditure_in_usd = @q.result.where.not(expenditure_id: nil).price_in_usd.sum(:price)
    @paid_expenditure_in_usd = @q.result.where.not(expenditure_id: nil).price_in_uzs.sum(:price)
    @total_expenditure_in_usd = Expenditure.price_in_usd
                                           .where('created_at >= ?', params[:q][:created_at_gteq])
                                           .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                                           .sum(:price)
    @total_expenditure_in_uzs = Expenditure.price_in_uzs
                                           .where('created_at >= ?', params[:q][:created_at_gteq])
                                           .where('created_at <= ?', params[:q][:created_at_end_of_day_lteq])
                                           .sum(:price)
  end

  def define_sale_destination; end

  def shortcuts; end
end
