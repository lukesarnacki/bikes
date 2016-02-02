class SendNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(coordinator_id)
    coordinator = Coordinator.find(coordinator_id)
    CoordinatorMailer.bikes_prepared_email(coordinator).deliver_later
    coordinator.notification_sent
  end
end
