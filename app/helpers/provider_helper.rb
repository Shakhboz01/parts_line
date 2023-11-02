module ProviderHelper
  def calculate_debt(provider)
    total_price = provider.delivery_from_counterparties.sum(:total_price)
    total_paid = provider.delivery_from_counterparties.sum(:total_paid)
    debt = number_to_currency(total_price - total_paid)
    link_to(debt.to_s, delivery_from_counterparties_path(q_other: { total_paid_less_than_price: "1" }))
  end
end
