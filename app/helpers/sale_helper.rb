module SaleHelper
  def show_warning(sale)
    return if sale.total_paid >= sale.total_price
    return if [sale.buyer.calculate_debt_in_usd, sale.buyer.calculate_debt_in_uzs].all?(&:negative?)

    days = [7, 14]
    color = '#63E6BE'
    if sale.created_at < (DateTime.current - days[1].days)
      color = '#f51000'
    elsif sale.created_at < (DateTime.current - days[0].days)
      color = '#FFD43B'
    end

    "<i class='fa-solid fa-triangle-exclamation' style='color: #{color};'></i>".html_safe
  end
end