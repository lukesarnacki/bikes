class CleanBikeJob < ActiveJob::Base
  queue_as :default

  def perform(bike_id)
    bike = Bike.find(bike_id)
    #Cleaner.new.clean(bike)
    sleep(1)
    bike.finished_cleaning
  end
end
