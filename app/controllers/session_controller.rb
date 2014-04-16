class SessionController < ApplicationController
  def change_password

  end

  def reset_password
    flash[:danger] = nil
    flash[:success] = nil
    flash[:warning] = nil
    encrypted_password = BCrypt::Engine.hash_secret(params[:password1], current_rbo_user.salt)
    if encrypted_password != current_rbo_user.encrypted_password
      flash[:danger] = 'try again'
    else
      if params[:password2] != params[:password]
        flash[:warning] = 'Passwords do not match, try again'
      else
        flash[:success] = 'Todo Bien'
      end
    end
    render action: 'change_password'
  end

end