require 'map'

module Monzo

  # Public: Transactions are movements of funds into or out of an account.
  #         Negative transactions represent debits (ie. spending money) and
  #         positive transactions represent credits (ie. receiving money).
  class Transaction

    # Public: Initialize a Transaction.
    #
    # params - A Hash of transaction parameters.
    def initialize(params)
      @params = Map.new(params)
    end

    def method_missing(m, *_)
      @params[m]
    end

    # Public: Find a transaction with the given transaction id.
    #
    # transaction_id - The id to find.
    # options - a Hash of options to request further information such as the
    #           merchant information (optional)
    #
    # Returns an instance of Monzo::Transaction.
    def self.find(transaction_id, options = {})
      response = Monzo.client.get("/transactions/#{transaction_id}", options)
      parsed_response = JSON.parse(response.body, :symbolize_names => true)

      Monzo::Transaction.new(parsed_response[:transaction])
    end

    # Public: Find all the transactions for a given account id.
    #
    # account_id - The account id to retrieve transactions from.
    #
    # Returns an Array of Monzo::Transaction.
    def self.all(account_id)
      response = Monzo.client.get("/transactions", :account_id => account_id)
      parsed_response = JSON.parse(response.body, :symbolize_names => true)

      parsed_response[:transactions].map do |item|
        Monzo::Transaction.new(item)
      end
    end

    # Public: Create an annotation for a given transaction id. You may store
    # your own key-value annotations against a transaction in its metadata.
    #
    # transaction_id - The transaction id to annotate.
    # metadata - a hash of annotations to add.
    #
    # Returns an instance of Monzo::Transaction with the annotations.
    def self.create_annotation(transaction_id, metadata)
      data = {}
      metadata.each do |k, v|
        data["metadata[#{k.to_s}]"] = v
      end
      response = Monzo.client.patch("/transactions/#{transaction_id}", data, {})
      parsed_response = JSON.parse(response.body, :symbolize_names => true)

      Monzo::Transaction.new(parsed_response[:transaction])
    end

  end
end
