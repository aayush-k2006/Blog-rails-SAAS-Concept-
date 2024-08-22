class ArticlesController < ApplicationController
    # http_basic_authenticate_with name: "ddh", password: "secret", except: [:index, :show]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_org, only: [:index, :show, :new, :create]

    def new
        @article = Article.new
    end

    def edit
        @article = Article.find(params[:id])
    end

    def create
        @article = @organization.users.find_by(id: current_user.id).articles.build(article_params)
        if @article.save
            redirect_to @article
        else
            # puts "inside else >>>>>>>>>>>>"
            render "new", status: :unprocessable_entity
        end
    end

    def update
        @article = Article.find(params[:id])

        if @article.update(article_params)
            redirect_to @article
        else
        
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @article = Article.find(params[:id])
        @article.destroy

        redirect_to root_path, status: :see_other
    end


    def show
        @article = Article.find(params[:id])
        @comment = @article.comments
    end

    def index
        if user_signed_in?
            @articles = @organization.articles
        else
            @articles = Article.all
        end
    end

    def find_org
        if user_signed_in?
        @organization_id = Membership.find_by(user_id: current_user.id).organization_id
        @organization = Organization.find_by(id: @organization_id)
        end
    end

    private 
    def article_params
        params.require(:article).permit(:title, :text, :status, :user_id, :organization_id)
    end
end
