class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
 
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    redirect_to root_url if signed_in?

    @user = User.new
  end

  # POST /users
  def create
    redirect_to root_url if signed_in?

    @user = User.new(params[:user])

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # GET /users/1/edit
  def edit
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])

    if current_user?(@user)
      redirect_to users_url, notice: "You can't destroy yourself."
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end


  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
