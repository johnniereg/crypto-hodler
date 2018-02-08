class HoldingsController < ApplicationController

    def index
        @holdings = Holding.all
    end
    
    def show
        @holding = Holding.find(params[:id])
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

    private
        def holding_params
            params.require(:holding).permit(:crypto, :amount)
        end
end
