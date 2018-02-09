class HoldingsController < ApplicationController

    def index
        @holdings = Holding.all
        tokens
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

    def tokens
        @tokens = HTTParty.get('https://api.coinmarketcap.com/v1/ticker/')
    end

    private
        def holding_params
            params.require(:holding).permit(:crypto, :amount)
        end
end
