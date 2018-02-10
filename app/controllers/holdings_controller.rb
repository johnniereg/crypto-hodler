class HoldingsController < ApplicationController

    def index
        @holdings = Holding.all
        @portfolio = build_portfolio
    end
    
    def show
        @holding = Holding.find(params[:id])
        @api_string = 'https://api.coinmarketcap.com/v1/ticker/' + @holding[:crypto] + '/'
        @response = HTTParty.get(@api_string)
    end

    def new
        @holding = Holding.new
    end

    def edit
        @holding = Holding.find(params[:id])
    end

    def create
        @holding = Holding.new(holding_params)

        if @holding.save
            redirect_to @holding
        else
            render 'new'
        end
    end

    def update
        @holding = Holding.find(params[:id])

        if @holding.update(holding_params)
            redirect_to @holding
        else
            render 'edit'
        end
    end

    def destroy
        @holding = Holding.find(params[:id])
        @holding.destroy

        redirect_to holdings_path
    end

    # Return CoinMarketCap API response for all coins
    def all_tokens
        all_tokens = HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
    end

    # Assemble holdings and API request into a portfolio
    def build_portfolio
        @portfolio = Array.new
        @all_tokens = all_tokens
        # @holdings = get_holdings
        @portfolio_names = portfolio_names
        # @names_and_amounts = names_and_amounts(@holdings)
        @all_tokens.each do |token|
            if @portfolio_names.include? token["id"]
                token["holding"] = get_amount(token["id"])
                @portfolio.push(token)
            end
        end
        puts @portfolio
    end

    # Return the holding amount of a given token
    def get_amount(name)
        @holding = get_holding(name)
        @amount = @holding["amount"]
    end

    # Return specific holding (name and amount)
    def get_holding(name)
        @holding = Holding.find_by crypto: name
    end

    # Return database holdings (names and amounts)
    def get_holdings
        @holdings = Holding.all
    end

    # Collect names of tokens held in the portfolio, used to carve down API results.
    def portfolio_names
        @portfolio_names = Array.new
        @holdings = get_holdings
        @holdings.each do |holding|
            @portfolio_names.push(holding.crypto)
        end
        @portfolio_names
    end

    # def names_and_amounts(holdings)
    #     @names_and_amounts = Array.new
    #     @holdings = holdings
    #     @holdings.each do |holding|
    #         @portfolio_names.push({"name" => holding.crypto, "amount" => holding.amount})
    #     end
    #     @names_and_amounts
    # end

    private
        def holding_params
            params.require(:holding).permit(:crypto, :amount)
        end
end
