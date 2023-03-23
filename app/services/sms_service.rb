class SmsService
    attr_reader :message

    def initialize(message)
        @message = message
    end

    def send_text!
        uri = URI.parse('https://textbelt.com/text')
        resp = Net::HTTP.post_form(uri, {
            :phone => '7818208626',
            :message => body,
            :key => api_key,
        })

        JSON.parse(resp.body)
    end

    def api_key
        key = ENV['TEXTBELT_KEY']
        key

    end

    def body
        body = "[#{message.name}] #{message.content}"
    end

end