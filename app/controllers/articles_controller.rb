class ArticlesController < ApplicationController
    http_basic_authenticate_with name: "wy", password: "123", except: [:index, :show]
 
    def index
        @articles = Article.all
    end
    def show
         @article = Article.find(params[:id])
    end
    def new
        @article = Article.new
    end
    def edit
        @article = Article.find(params[:id])
    end
    def create
 	@article = Article.new(params.require(:article).permit(:title, :text))
        if @article.save
            redirect_to @article
	else
	    render 'new'
        end
    end
    def update
      @article = Article.find(params[:id])
 
      if @article.update(article_params)
        redirect_to @article
      else
        render 'edit'
      end
    end
    def uploadpro
    @product=Product.new(params[:product]);
    unless request.get?
      filename = uploadfile(@product.image_url)
      @product.image_url = filename
      @product.save
    end
    redirect_to search_path
    end
    def uploadfile(file)
    if !file.original_filename.empty?
      @filename = file.original_filename
      #设置目录路径，如果目录不存在，生成新目录
      FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
      #写入文件
      ##wb 表示通过二进制方式写，可以保证文件不损坏
      File.open("#{Rails.root}/public/upload/#{@filename}", "wb") do |f|
        f.write(file.read)
      end
      return @filename
    end
    end

    def destroy
      @article = Article.find(params[:id])
      @article.destroy
 
      redirect_to articles_path
    end
    private
	def article_params
	   params.require(:article).permit(:title,:txt)
	end
end
