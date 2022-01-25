class ReservationsController < ApplicationController
  include Partner

  skip_before_action :verify_authenticity_token

  def import
    res = form.submit
    render json: { data: res }
  rescue Partner::InvalidPartnerError, ActiveRecord::RecordInvalid => e
    Rails.logger.error(tags: ['import'], message: e.message, backtrace: e.backtrace.take(5).join('/n') || '')
    render json: { message: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error(tags: ['import'], message: e.message, backtrace: e.backtrace.take(5).join('/n') || '')
    render json: { message: 'unexpected error occurred' }, status: :internal_server_error
  end

  private

  def form
    alpha_form = Partner::AlphaCompanyForm.new(params)
    return alpha_form if alpha_form.valid?

    beta_form = Partner::BetaCompanyForm.new(params)
    return beta_form if beta_form.valid?

    raise Partner::InvalidPartnerError
  end
end