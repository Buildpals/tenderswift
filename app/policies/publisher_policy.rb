# frozen_string_literal: true

class PublisherPolicy
  attr_reader :publisher, :publisher_profile

  def initialize(publisher, publisher_profile)
    @publisher = publisher
    @publisher_profile = publisher_profile
  end

  def dashboard?
    owns_publisher_profile?
  end

  def edit?
    owns_publisher_profile?
  end

  def update?
    owns_publisher_profile?
  end

  private

  def owns_publisher_profile?
    @publisher == @publisher_profile
  end
end
