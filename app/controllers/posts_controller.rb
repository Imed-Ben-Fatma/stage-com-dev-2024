class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[posts_by_user create update destroy]
  before_action :set_post, only: %i[show update destroy update_blocked update_archived] 
  include Rails.application.routes.url_helpers

#-------------------------------------------------------------------------------------
  # GET /posts
  def index
    if params[:type]
      @posts = Post.includes(:adresse, :equipements, :reservations, images_attachments: :blob)
                   .with_type_logement(params[:type])
                   .where(archived: false, blocked: false)
                   .page(params[:page])
    elsif params[:type_place]
      @posts = Post.includes(:adresse, :equipements, :reservations, images_attachments: :blob)
                   .with_type_place(params[:type_place])
                   .where(archived: false, blocked: false)
                   .page(params[:page])
    else
      @posts = Post.includes(:adresse, :equipements, :reservations, images_attachments: :blob)
                   .where(archived: false, blocked: false)
                   .page(params[:page])
    end
  test=@posts
  render json: @posts, meta: pagination_meta(test), adapter: :json
     
  end
  
#-------------------------------------------------------------------------------------

# GET /posts_by_user
  def posts_by_user
    authorize :post, :posts_by_user?

    if current_user.role == 'owner'
      user_id = current_user.id
      @posts = Post.includes(images_attachments: :blob).where(user_id: user_id, blocked: false)
    elsif current_user.role == 'admin' && params[:user_id]
      user_id = params[:user_id]
      @posts = Post.includes(images_attachments: :blob).where(user_id: user_id, blocked: false)
    else
      return render json: { message: "unauthorized access" }, status: :bad_request
    end

    if params[:en_cours_de_traitement]==="true"
      @posts = @posts.with_active_reservations
    end

    if user_id
      render json: @posts, each_serializer: PostByUserSerializer
    else
      render json: { message: "user_id is missing" }, status: :bad_request
    end
  end

#-------------------------------------------------------------------------------------

# GET /posts/1
def show
  if current_user

    case current_user.role
      when 'admin'
        render json: @post, serializer: PostDetailesSerializer
      when 'owner'

        if !@post.blocked
          render json: @post, serializer: PostDetailesSerializer
        else
          render json: { error: "Post not found or not accessible" }, status: :not_found
        end

      else

        if @post.blocked|| @post.archived
          render json: { error: "Post not found or not accessible" }, status: :not_found
        else
          render json: @post, serializer: PostDetailesSerializer
        end
      end

  else
    if @post.blocked || @post.archived
      render json: { error: "Post not found or not accessible" }, status: :not_found
    else
      render json: @post, serializer: PostDetailesSerializer
    end
  end
end

#-------------------------------------------------------------------------------------

  # POST /posts
  def create
    @post = current_user.posts.build(post_params.except(:images, :type_logements))
    authorize @post

    if @post.save
      @post.create_adresse!(post_params[:adresse_attributes]) if post_params[:adresse_attributes]

      if post_params[:type_logements]
        @post.build_type_logement(post_params[:type_logements])
      end

      images = post_params[:images]
      if images
        Array(images).each { |image| @post.images.attach(image) }
      end

      render json: @post.to_json(include: [:adresse, :equipements, :type_logement]), status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end
#-------------------------------------------------------------------------------------
  # PATCH/PUT /posts/1
  def update
    authorize @post
  
    if @post.update(post_params_update.except(:images, :images_remove, :equipements_attributes, :type_logement))
      # Update or create adresse
      if post_params[:adresse_attributes]
        if @post.adresse
          @post.adresse.update(post_params[:adresse_attributes])
        else
          @post.create_adresse!(post_params[:adresse_attributes])
        end
      end


    # Update or create equipements
    if post_params_update[:equipements_attributes]
      equipements_params = post_params_update[:equipements_attributes].values

      # Collect all provided equipment names
      provided_equipements_names = equipements_params.map { |e| e[:nom] }

      # Remove equipment not provided in the params
      @post.equipements.where.not(nom: provided_equipements_names).destroy_all

      
      equipements_params.each do |equipement_param|
        equipement = @post.equipements.find_by(nom: equipement_param[:nom])
        if equipement
          equipement.update(description: equipement_param[:description]) if equipement.description != equipement_param[:description]
        else
          @post.equipements.create(equipement_param)
        end
      end
    end

      
  

    # type_logements
    if post_params_update[:type_logement]
      type_logements_params = post_params_update[:type_logement]
      if @post.type_logement
        @post.type_logement.update(type_logements_params)
      else
        @post.build_type_logement(type_logements_params)

      end
    end

      # Attach new images
      if post_params_update[:images]
        Array(params[:images]).each { |image| @post.images.attach(image) }
      end
  
      # Remove images
      if post_params_update[:images_remove]
        Array(params[:images_remove]).each { |image_id| @post.images.find_by(id: image_id)&.purge }
      end
  
      render json: @post.to_json(include: [:adresse, :equipements, :type_logement])
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

#-------------------------------------------------------------------------------------
    # PATCH/PUT /post/archived
    def update_archived
      authorize @post
      if (@post.user_id == current_user.id) || (current_user.role=='admin')
        if @post.update(archived: !@post.archived)
          render json: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      else
          render json: { error: 'You are not authorized to perform this action.' }, status: :unprocessable_entity
      end
    end
#-------------------------------------------------------------------------------------
        # PATCH/PUT /post/blocked
        def update_blocked
          authorize @post
          if (current_user.role=='admin')
            if @post.update(blocked: !@post.blocked)
              render json: @post
            else
              render json: @post.errors, status: :unprocessable_entity
            end
          else
              render json: { error: 'You are not authorized to perform this action.' }, status: :unprocessable_entity
          end
        end

#-------------------------------------------------------------------------------------
  # DELETE /posts/1
  def destroy
    authorize @post
    @post.destroy
  end
#-------------------------------------------------------------------------------------
  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params_update
    params.permit(
      :titre, :description, :nbrChambres, :nbrLits, :prix, :regles, :nbrSalleDeBain, :archived, :blocked,
      adresse_attributes: [:id, :rue, :ville, :pays, :localisationGPS],
      equipements_attributes: [:nom, :description],
      type_logement: [:type, :typePlace],
      images: [],
      images_remove: []
    )
  end

  def post_params
    params.permit(
      :titre, :description, :nbrChambres, :nbrLits, :prix, :regles, :nbrSalleDeBain,
      images: [],
      adresse_attributes: [:rue, :ville, :pays, :localisationGPS],
      equipements_attributes: [:nom, :description],
      type_logements: [:type, :typePlace]
    )
  end

  def pagination_meta(posts)
    {
      current_page: posts.current_page,
      next_page: posts.next_page,
      prev_page: posts.prev_page,
      total_pages: posts.total_pages,
      total_count: posts.total_count
    }
  end
  
end
