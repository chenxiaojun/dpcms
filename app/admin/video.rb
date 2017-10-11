# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Video do
  menu priority: 3, parent: '资讯管理', label: '视频列表'
  belongs_to :video_group, optional: true
  permit_params :name, :video_link, :title_desc, :cover_link, :video_duration, :top, :published,
                :description, :video_type_id, video_en_attributes: [:name, :title_desc, :description]
  scope :all
  scope('main_videos') do |scope|
    scope.where(is_main: true)
  end

  @types = VideoType.all.collect do |type|
    type_name = type.published ? type.name + ' [已发布]' : type.name
    [type_name, type.id]
  end

  filter :name
  filter :published
  filter :top
  filter :video_type_id, as: :select, collection: @types

  index do
    render 'index', context: self
  end

  member_action :publish, method: :post do
    resource.publish!
    redirect_back fallback_location: admin_videos_url, notice: '发布成功'
  end

  member_action :unpublish, method: :post do
    resource.unpublish!
    resource.untop! if resource.top
    redirect_back fallback_location: admin_videos_url, notice: '取消发布成功'
  end

  member_action :top, method: :post do
    resource_type = resource.video_type || resource.build_video_type
    list = resource_type.videos.published.topped
    list.present? && list.map(&:untop!)
    resource.top!
    resource.publish! unless resource.published
    redirect_back fallback_location: admin_videos_url, notice: '置顶成功'
  end

  member_action :untop, method: :post do
    resource.untop!
    redirect_back fallback_location: admin_videos_url, notice: '取消置顶成功'
  end

  member_action :main_video, method: :post do
    # 取消该类别下所有视频的主视频
    resource&.video_group.videos.update(is_main: false)
    # 更新当前视频为主视频
    resource.update(is_main: true)
    redirect_to :back, notice: '设置成功'
  end

  action_item :add, only: :index do
    link_to '视频类别', admin_video_types_path
  end

  form partial: 'edit_info'

  controller do
    def update
      unless resource.video_type_id.eql? update_params['video_type_id'].to_i
        # 说明更换了类别 那么不管 反正你要换类别，你先取消置顶再说
        resource.untop!
      end
      # 如果取消发布，也会先取消置顶
      resource.untop! if update_params['published'].to_i.zero?

      # 保存数据
      flash[:notice] = if resource.update!(update_params)
                         '视频更新成功'
                       else
                         '视频更新失败'
                       end
      redirect_to admin_videos_url
    end

    private

    def update_params
      params.require(:video).permit(:name,
                                    :video_type_id,
                                    :video_link,
                                    :cover_link,
                                    :title_desc,
                                    :video_duration,
                                    :published,
                                    :top,
                                    :description,
                                    video_en_attributes: [:id, :name, :title_desc, :description])
    end
  end
end
