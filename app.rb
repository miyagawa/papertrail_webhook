require 'json'
require 'uri'
require 'net/http'
require 'net/https'

module PapertrailWebhook
  class App < Sinatra::Base
    get '/' do
      "200\n"
    end

    post "/webhook/#{ENV['SECRET']}" do
      payload = JSON.parse(params[:payload])
      p payload

      payload['events'].each do |event|
        url = URI.parse 'https://api.pushbullet.com/v2/pushes'
        params = {
          type: "link",
          title: "Papertrail alert from #{event['hostname']}",
          body: event['message'],
          url: "#{payload['saved_search']['html_search_url']}?center_on_id=#{event['id']}",
        }

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(url.request_uri)
        req.set_form_data(params)
        req.basic_auth(ENV['PUSHBULLET_TOKEN'], '')

        res = http.request(req)
        p res.body
      end

      'ok'
    end
  end
end
