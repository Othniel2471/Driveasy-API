class CarsController < ApplicationController
  def index
    @cars = Car.all

    render json: @cars
  end

  def create
    @car = Car.new(car_params)
    if @car.image.attached?
     @car.image_url = url_for(@car.image)
    else
      puts "Image not attached to the car"
    end
    if @car.save
      render json: { car: @car, message: 'Car created successfully' }, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  def show
  @car = Car.find(params[:id])
  if @car.image.attached?
    @car_data = @car.as_json(include: :image)
    @car_data["image_url"] = url_for(@car.image)
  else
    @car_data = @car.as_json
  end
  render json: @car_data
end

  def car_params
    params.require(:car).permit(:name, :price, :color, :model, :image)
  end
end
