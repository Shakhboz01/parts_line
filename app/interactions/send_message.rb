require "telegram/bot"

class SendMessage < ActiveInteraction::Base
  string :message

  def execute
    token = ENV["TELEGRAM_TOKEN"]
    bot = Telegram::Bot::Client.new(token)
    begin
      bot.api.send_message(chat_id: ENV["TELEGRAM_CHAT_ID"], text: message)
    rescue => exception
      puts "error"
    end
  end
end
