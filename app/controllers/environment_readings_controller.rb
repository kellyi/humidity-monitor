class EnvironmentReadingsController < ApplicationController
  def index
    @environment_readings = EnvironmentReading.by_recency
  end
end
