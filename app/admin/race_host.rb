ActiveAdmin.register RaceHost do
  config.batch_actions = false

  permit_params :name
  controller do
    def destroy
      if resource.races.exists?
        flash[:error] = '已有赛事关联此主办方，不允许删除'
      else
        resource.destroy
      end
      redirect_to action: 'index'
    end
  end
end
