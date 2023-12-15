TODO:
 Add price_in_usd field in TransactionHisory, Product, Expenditure, sales
 Add user reference to: delivery_from_counterparty
 Add delivery_from_counterparties
 Add priority enum for product: xodovoy sredniy ne-xodovoy
 Add boolean to product: importniy
 Add discount table, fields: price_in_usd:oolean, price:decimal, verified:boolean default false,sales:references, delivery_from_counterparties:references, user:references

QUESTIONS:
 What king of expenditures do you have
 Send me a photo that was forgotten
 List of workers, their roles, allowed_to_use, daily_salary
 How to calculate productivity of workers
 How to find if a product is fast-sold or not

    READY features:
  main branch
PUNDIT (rails g pundit:policy MODEL --no-test)
DEVISE ready
interaction ready
bootstrap ready
navigation ready
template ready
js ready
users deletion process ready

  Tasks:
1) customize registration proccess
2) fill Users controller
3) Add interaction
4) Add telegram messaging
5) create a new branch and add pereklichka
6) create a new branch and add a custom login page like the paper_app