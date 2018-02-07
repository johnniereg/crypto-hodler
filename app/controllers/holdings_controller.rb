class HoldingsController < ApplicationController
    def new
    end

    def create
        render plain: params[:holding].inspect
    end
end
