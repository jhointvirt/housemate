module RentedAccommodationModule
  class Filter
    attr_accessor :current_user, :params
  
    def initialize(current_user = nil, params = {})
      @current_user = current_user
      @params = params
    end
  
    def execute
      accommodations = RentedAccommodation.all
      accommodations = where_cost_more(accommodations)
      accommodations = where_cost_less(accommodations)
      accommodations = where_adress_like(accommodations)
      accommodations
    end
  
    private
  
    def where_cost_more(accommodations)
      return accommodations unless params[:cost_more]

      accommodations.where("cost >= ?", params[:cost_more])
    end

    def where_cost_less(accommodations)
      return accommodations unless params[:cost_less]

      accommodations.where("cost <= ?", params[:cost_less])
    end

    def where_adress_like(accommodations)
      return accommodations unless params[:address]

      accommodations.where("address LIKE ?", "%#{params[:address]}%")
    end
  end
end