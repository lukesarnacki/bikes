class Bike < ActiveRecord::Base
  include AASM

  belongs_to :coordinator

  aasm column: :state do
    state :new, initial: true
    state :servicing
    state :cleaning
    state :ready

    event :service, after_commit: :schedule_servicing do
      transitions from: :new, to: :servicing
    end

    event :clean, after_commit: :schedule_cleaning do
      transitions from: :servicing, to: :cleaning
    end

    event :finish, after_commit: :notify_coordinator do
      transitions from: :cleaning, to: :ready
    end
  end

  scope :not_ready, -> { where.not(state: :ready) }

  def start_preparation
    service!
  end

  def finished_servicing
    clean!
  end

  def finished_cleaning
    finish!
  end

  def schedule_servicing
    ServiceBikeJob.perform_later(self.id)
  end

  def schedule_cleaning
    CleanBikeJob.perform_later(self.id)
  end

  def notify_coordinator
    coordinator.preparation_finished
  end
end
