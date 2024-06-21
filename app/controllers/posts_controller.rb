class PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  # GET /posts
  def index
    @posts = Post.includes(:adresse, :equipements).all
    render json: @posts.to_json(include: [:adresse, :equipements, :images])
  end

  # GET /posts/1
  def show
    render json: @post.as_json(include: [:adresse, :equipements]).merge(
      images: @post.images.map do |image|
        { id: image.id, 
          url: url_for(image) }
      end
    )
  end

  # POST /posts
  def create
    @post = Post.new(post_params.except(:images))

    if @post.save

      if post_params[:adresse_attributes]
        @post.create_adresse!(post_params[:adresse_attributes])
      end

      if post_params[:equipements_attributes]
        post_params[:equipements_attributes].each do |equipement_params|
          @post.equipements.create(equipement_params)
        end
      end

      images = params[:images]

      if images
        Array(images).each do |image|
          @post.images.attach(image)
        end
      end

      render json: @post.to_json(include: [:adresse, :equipements]), status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params_update.except(:images, :images_remove))
      if post_params[:adresse_attributes]
        if @post.adresse
          @post.adresse.update(post_params[:adresse_attributes])
        else
          @post.create_adresse!(post_params[:adresse_attributes])
        end
      end

      if post_params[:equipements_attributes]
        post_params[:equipements_attributes].each do |equipement_params|
          if equipement_params[:_destroy]
            @post.equipements.find(equipement_params[:id]).destroy
          else
            @post.equipements.find_or_initialize_by(id: equipement_params[:id]).update(equipement_params.except(:_destroy))
          end
        end
      end

      images = params[:images]
      if images
        Array(images).each do |image|
          @post.images.attach(image)
        end
      end

      images_remove = params[:images_remove]
      if images_remove
        Array(images_remove).each do |image_id|
          @post.images.find_by(id: image_id)&.purge
        end
      end

      render json: @post.to_json(include: [:adresse, :equipements])
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end



  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params_update
    params.permit(
      :titre, :description, :nbrChambres, :nbrLits, :prix, :logement_type, :regles,
      images: [], images_remove: [],
      adresse_attributes: [:id, :rue, :ville, :pays, :localisationGPS],
      equipements_attributes: [:id, :nom, :description, :_destroy]
    )
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.permit(
      :titre, :description, :nbrChambres, :nbrLits, :prix, :logement_type, :regles,
      images: [],
      adresse_attributes: [:rue, :ville, :pays, :localisationGPS],
      equipements_attributes: [:nom, :description]
    )
  end
end
