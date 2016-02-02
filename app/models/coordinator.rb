class Coordinator < ActiveRecord::Base
  include AASM

  has_many :bikes

  aasm column: :state do
    state :new, initial: true
    state :preparing_bikes
    state :sending_notification
    state :done

    event :start, after_commit: :prepare_bikes do
      transitions from: :new, to: :preparing_bikes
    end

    event :send_notification, after_commit: :schedule_sending_notification do
      transitions from: :preparing_bikes, to: :sending_notification
    end

    event :finish do
      transitions from: :sending_notification, to: :done
    end
  end

  def preparation_finished
    send_notification! if all_bikes_ready?
  end

  def notification_sent
    finish!
  end

  def start_preparations
    start!
  end

  private

  def prepare_bikes
    bikes.each do |bike|
      bike.start_preparation
    end
  end

  def all_bikes_ready?
    bikes.not_ready.empty?
  end

  def schedule_sending_notification
    SendNotificationJob.perform_later(self.id)
  end
end
