class ServiceBikeJob < ActiveJob::Base
  queue_as :default

  def perform(bike_id)
    bike = Bike.find(bike_id)
    Mechanic.new.service(bike)
    bike.finished_servicing
  end
end
