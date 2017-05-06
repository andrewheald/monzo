module Monzo
  class Account

    attr_reader :id, :description, :created

    def initialize(params)
      @id = params[:id]
      @description = params[:description]
      @created = params[:created]
    end

    def self.all
      client = Monzo::client
      response = client.get("/accounts")
      json = JSON.parse(response.body, :symbolize_names => true)

      json[:accounts].map do |item|
        Monzo::Account.new(item)
      end
    end
  end
end
