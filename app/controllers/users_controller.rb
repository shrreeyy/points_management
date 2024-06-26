class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register]
  before_action :set_user, only: [:credit, :debit]

  def register
    user = User.new(user_params)

    if user.save
      render json: { message: I18n.t('success.messages.registration_success') }, status: :created
    else
      render_error(user.errors.full_messages.to_sentence)
    end
  end

  def credit
    purchase_amount = params[:purchase_amount].to_f

    unless purchase_amount > 0
      render_error(I18n.t('errors.messages.invalid_purchase_amount')) and return
    end

    earn_ratio = configuration.earn_ratio.to_f
    points_earned = purchase_amount * earn_ratio
    update_points_balance(points_earned)

    render_credit_response(points_earned)
  end

  def debit
    burn_ratio = configuration.burn_ratio.to_f
    redemption_amount = params[:redemption_amount].to_f

    unless redemption_amount > 0 && burn_ratio > 0
      render_error(I18n.t('errors.messages.invalid_redemption_amount') ) and return
    end

    points_to_deduct = redemption_amount / burn_ratio

    unless sufficient_points_to_deduct?(points_to_deduct)
      render_insufficient_balance_response(points_to_deduct) and return
    end

    update_points_balance(-points_to_deduct)
    render_debit_response(points_to_deduct)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def update_points_balance(points)
    @user.points_balance += points
    @user.save
  end

  def render_credit_response(points_earned)
    if @user.errors.empty?
      render json: {
        user_id: @user.id,
        points_earned: points_earned,
        new_balance: @user.points_balance
      }, status: :ok
    else
      render_error(@user.errors.full_messages.to_sentence)
    end
  end

  def sufficient_points_to_deduct?(points_to_deduct)
    points_to_deduct > 0 && @user.points_balance >= points_to_deduct && @user.points_balance >= 1000
  end

  def render_insufficient_balance_response(points_to_deduct)
    if @user.points_balance < 1000
      render_error(I18n.t('errors.messages.minimum_points_requirement_not_met'))
    else
      render_error(I18n.t('errors.messages.insufficient_balance') )
    end
  end

  def render_debit_response(points_to_deduct)
    if @user.errors.empty?
      render json: {
        user_id: @user.id,
        points_deducted: points_to_deduct,
        new_balance: @user.points_balance
      }, status: :ok
    else
      render json: { errors: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
end
