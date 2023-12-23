require "telegram/bot"

class SendMessage < ActiveInteraction::Base
  string :message
  string :image_name, default: nil
  boolean :is_photo, default: false

  def execute
    token = ENV["TELEGRAM_TOKEN"]
    bot = Telegram::Bot::Client.new(token)
    begin
      img_path = Rails.root.join("app/assets/images/#{image_name}").to_s

      if is_photo
        bot.api.send_photo(
          chat_id: ENV["TELEGRAM_CHAT_ID"],
          photo: Faraday::UploadIO.new(img_path, 'image/jpeg')
        )
      else
        bot.api.send_message(
          chat_id: ENV["TELEGRAM_CHAT_ID"],
          text: message,
          parse_mode: "HTML"
        )
      end
    rescue => exception
      puts "error"
    end
  end
end
