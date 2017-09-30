# rubocop:disable Metrics/BlockLength
BANNER_SOURCE_TYPE = %w(race info video link).freeze
TRANS_SOURCE_TYPE = BANNER_SOURCE_TYPE.collect { |d| [I18n.t("banner.#{d}"), d] }
ActiveAdmin.register Banner do
  menu priority: 5, parent: '首页管理'
  config.batch_actions = false
  config.filters = false
  config.sort_order = 'position_asc'

  form partial: 'form'

  index do
    render 'index', context: self
  end

  controller do
    def create
      position = (Banner.last&.id.to_i + 1) * 100000
      @banner = Banner.new banner_params.merge(position: position)

      if @banner.save
        flash[:notice] = '新建banner成功'
        redirect_to admin_banners_url
      else
        render :new
      end
    end

    def banner_params
      params.require(:banner).permit(:image,
                                     :link,
                                     :source_id,
                                     :source_type)
    end
  end

  member_action :reposition, method: :post do
    banner = Banner.find(params[:id])
    next_banner = params[:next_id] && Banner.find(params[:next_id][7..-1])
    prev_banner = params[:prev_id] && Banner.find(params[:prev_id][7..-1])
    if params[:prev_id].blank?
      position = next_banner.position / 2
    elsif params[:next_id].blank?
      position = prev_banner.position + 100000
    else
      position = (prev_banner.position + next_banner.position) / 2
    end
    banner.update(position: position)
  end
end
