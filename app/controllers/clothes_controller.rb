# app/controllers/clothes_controller.rb
class ClothesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_clothe,         only: %i[show edit dibs undibs]
  before_action :authorize_owner!,   only: %i[edit]

  # MAIN FEED: hide dibbed items
  def index
  @clothes = Clothe
      .where(dibbed_by_id: nil) # only available items on the homepage
      .includes(:user, :dibbed_by, photos_attachments: :blob)
      .order(created_at: :desc)
  end


  def show
    @item = @clothe  # if your show view uses @item
  end

  def new
    @clothe = Clothe.new
  end

  def create
    @clothe = current_user.clothes.build(clothe_params)
    if @clothe.save
      redirect_to clothe_path(@clothe), notice: "Clothing added"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # “My Listings”: show ALL of my posts (including dibbed)
  def mine
    @clothes = current_user.clothes
      .includes(:user, photos_attachments: :blob)
      .order(created_at: :desc)
  end

  # My Dibs: items I called dibs on
  def my_dibs
    @clothes = Clothe
      .where(dibbed_by_id: current_user.id)
      .includes(:user, :dibbed_by, photos_attachments: :blob)
      .order(dibbed_at: :desc)
  end

  def edit
    # @clothe set by set_clothe
  end

  # --- DIBS ACTIONS ---

  def dibs
    if @clothe.user_id == current_user.id
      return redirect_back fallback_location: clothe_path(@clothe), alert: "You can’t call dibs on your own item."
    end

    if @clothe.dibbed_by_id.present?
      redirect_back fallback_location: clothe_path(@clothe), alert: "Already called."
    else
      @clothe.update!(dibbed_by_id: current_user.id, dibbed_at: Time.current)
      redirect_back fallback_location: clothe_path(@clothe), notice: "You called dibs!"
    end
  end

  def undibs
    if @clothe.dibbed_by_id == current_user.id || @clothe.user_id == current_user.id
      @clothe.update!(dibbed_by_id: nil, dibbed_at: nil)
      redirect_back fallback_location: clothe_path(@clothe), notice: "Item has been undibed"
    else
      redirect_back fallback_location: clothe_path(@clothe), alert: "Not authorized to release dibs"
    end
  end

  private

  def set_clothe
    @clothe = Clothe.find(params[:id])
  end

  def authorize_owner!
    redirect_to clothe_path(@clothe), alert: "You can only edit your own post." unless @clothe.user_id == current_user.id
  end

  def clothe_params
    params.require(:clothe).permit(:title, :item_type, :description, :size, :condition, :brand, photos: [])
  end
end
