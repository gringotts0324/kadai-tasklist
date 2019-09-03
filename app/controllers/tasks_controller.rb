class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
      @task = current_user.tasks.build
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end 
  
  def show 
     @task = Task.find(params[:id])
  end

  def new 
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(tasks_params)
    
    if @task.save
      flash[:success] = 'Taskは正常に投稿されました'
      redirect_to @task
    else 
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'Taskは投稿されませんでした'
      render :new
    end
  end  

  def edit 
  end 

  def update
    if @task.update(tasks_params)
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to @task
    else 
      flash.now[:danger] = 'Taskは更新されませんでした'
      render :edit
    end
  end 

  def destroy 
    @task.destroy
    
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to tasks_url
  end 


  private 

  def set_task
    @task = Task.find(params[:id])
  end  

  def tasks_params
    params.require(:task).permit(:content, :status, :user_id)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end

end