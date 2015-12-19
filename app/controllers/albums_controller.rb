class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except:[:index,:show]
  before_action :is_owner, only:[:edit,:update,:destroy]
  # GET /albums
  # GET /albums.json
  def index
    if current_user
      @albums = (Album.where(locked: false) + Album.where(user_id: current_user.id)).uniq
    else
      @albums = Album.where(locked: false) 
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    unless  !@album.locked || @album.user == current_user
      flash[:error]="此相册并未公开"
      redirect_to :back
    end
  end

  # GET /albums/new
  def new
    @album = Album.new
  end
  
  def my
    @albums = current_user.albums
  end

  # GET /albums/1/edit
  def edit
    @photos = @album.photos
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(album_params)
    @album.user = current_user 
    respond_to do |format|
      if @album.save
        format.html { redirect_to my_album_path, notice: 'Album was successfully created.' }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to my_album_path, notice: 'Album was successfully updated.' }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to my_album_url, notice: 'Album was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:name, :description, :locked)
    end

    def is_owner
      unless current_user && @album.user == current_user
        flash[:error]="没有用户权限"
        redirect_to :back
      end
    end
end
