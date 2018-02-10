class HoldingsController < ApplicationController

    def index
        @holdings = Holding.all
        puts build_portfolio
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

    def all_tokens
        all_tokens = HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
        # JSON.parse all_tokens, symbolize_names: true
    end

    def build_portfolio
        @portfolio = Array.new
        @all_tokens = all_tokens
        @portfolio_names = portfolio_names
        @all_tokens.each do |token|
            if @portfolio_names.include? token["id"]
                @portfolio.push(token)
            end
        end
        @portfolio
    end

    def portfolio_names
        @portfolio_names = Array.new
        @holdings = Holding.all
        @holdings.each do |holding|
            @portfolio_names.push(holding.crypto)
        end
        @portfolio_names
    end

    private
        def holding_params
            params.require(:holding).permit(:crypto, :amount)
        end
end
