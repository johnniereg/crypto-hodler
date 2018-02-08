class HoldingsController < ApplicationController
    
    def show
        @holding = Holding.find(params[:id])
    end

    def new
    end

    def create
        @holding = Holding.new(holding_params)

        @holding.save
        redirect_to @holding
        # render plain: params[:holding].inspect
    end

    private
        def holding_params
            params.require(:holding).permit(:crypto, :amount)
        end
end
