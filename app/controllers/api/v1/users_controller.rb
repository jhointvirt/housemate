class Api::V1::UsersController < ApplicationController
  def create
    @created_user = UserService.new.create(params)

    if @created_user && @created_user.errors.empty?
      render json: @created_user, status: :ok
    else
      render json: !!@created_user ? @created_user.errors : 'User exist', status: :bad_request
    end
  end
end
