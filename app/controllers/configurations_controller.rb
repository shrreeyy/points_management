class ConfigurationsController < ApplicationController
  def show
    render json: configuration
  end

  def create
    # Since we only need to one configuration, we are updating the existing configuration instead of creating a new one.
    if configuration.update(configuration_params)
      render json: { message: I18n.t('success.messages.configuration_updated') }, status: :created
    else
      render_error(configuration.errors.full_messages.to_sentence)
    end
  end

  private

  def configuration_params
    params.require(:configuration).permit(:earn_ratio, :burn_ratio)
  end
end
