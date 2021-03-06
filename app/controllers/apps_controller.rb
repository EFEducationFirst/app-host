class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy, :comments]

  def index
    unless User.admin.exists?
      redirect_to new_user_path and return
    end
    unless signed_in?
      redirect_to new_session_path and return
    end
    @apps = App.active.all
    @has_archived = App.archived.count > 0
  end

  def show
    unless signed_in?
      redirect_to new_session_path and return
    end
    redirect_to app_plats_path @app
  end

  def new
    unless signed_in?
      redirect_to new_session_path and return
    end
    @app = App.new
  end

  def create
    authorize!(:create, App)
    app = App.create(app_params.merge(user_id:current_user.id))
    redirect_to root_path
  end

  def edit
    unless signed_in?
      redirect_to new_session_path and return
    end
    render 'new'
  end

  def update
    authorize!(:update, @app)
    @app.update app_params
    redirect_to root_path
  end

  def destroy
    authorize!(:destroy, @app)
    @app.destroy!
    redirect_to root_path
  end

  def archived
    unless signed_in?
      redirect_to new_session_path and return
    end
    @apps = App.archived.all
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_app
    @app = App.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def app_params
    params.require(:app).permit(:name,:desc,:archived);
  end
end