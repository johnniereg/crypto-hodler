class HoldingsController < ApplicationController

    def index
        @holdings = Holding.all
        puts all_tokens[0]
        puts @holdings.to_a[0]
        puts portfolio_names
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
        all_tokens = HTTParty.get('https://api.coinmarketcap.com/v1/ticker/', format: :plain)
        JSON.parse all_tokens, symbolize_names: true
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
