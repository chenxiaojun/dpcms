# rubocop:disable Metrics/BlockLength
PRODUCT_TYPES = Product.product_types.keys
TRANS_PRODUCT_TYPES = PRODUCT_TYPES.collect { |d| [I18n.t("product.#{d}"), d] }
ActiveAdmin.register Product, namespace: :shop do
  config.batch_actions = false
  config.sort_order = 'published_desc'
  filter :title
  filter :published
  filter :recommended
  filter :by_root_category_in, label: '主类别', as: :select, collection: Category.roots_collection

  permit_params :title, :icon, :description, :product_type, :category_id,
                :published, :freight_id, :freight_free,
                master_attributes: [:original_price, :price, :stock,
                                    :volume, :origin_point, :weight]

  sidebar '侧边栏', only: [:edit, :update, :variants] do
    product_sidebar_generator(self)
  end

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      @product = Product.new(permitted_params[:product])
      if @product.save
        flash[:notice] = '新建商品详情成功'
        redirect_to edit_shop_product_path(@product)
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      if @product.update(permitted_params[:product])
        flash[:notice] = '修改商品详情成功'
        redirect_to edit_shop_product_path(@product)
      else
        flash[:error] = '修改商品详情失败'
        render :edit
      end
    end
  end

  member_action :publish, method: :post do
    Product.find(params[:id]).publish!
    redirect_back fallback_location: shop_products_url, notice: '上架商品成功'
  end

  member_action :unpublish, method: :post do
    Product.find(params[:id]).unpublish!
    redirect_back fallback_location: shop_products_url, notice: '已下架商品'
  end

  member_action :recommend, method: :post do
    Product.find(params[:id]).recommend!
    redirect_back fallback_location: shop_products_url, notice: '推荐商品成功'
  end

  member_action :unrecommend, method: :post do
    Product.find(params[:id]).unrecommend!
    redirect_back fallback_location: shop_products_url, notice: '已取消推荐商品'
  end
end