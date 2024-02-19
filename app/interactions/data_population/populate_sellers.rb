module DataPopulation
  class PopulateSellers < ActiveInteraction::Base
    def execute
      sellers_data = JSON.parse(File.read('app/assets/javascripts/sellers.json'))
      sellers_data.each do |seller_data|
        create_seller(seller_data)
      end
    end

    private

    def create_seller(data)
      provider =
        Provider.create(
          name: data['seller_name'],
          phone_number: data['phone_number'],
          active: true
        )
    end
  end
end
