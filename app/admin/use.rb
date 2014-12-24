ActiveAdmin.register Use do
  menu :priority => 6
  actions :all, except: [:edit, :update, :destroy]
  config.filters = false

  controller do
    def scoped_collection
      Use.not_deleted
    end
  end

  index do
    column "Photo/Video Uses", :description
    column "" do |resource|
      links = ''.html_safe
      links += link_to 'Delete', delete_use_admin_use_path(resource)
      links
    end
  end

  controller do
    def create
      @use = Use.new(params[:use])
      if @use.save
        flash[:notice] = "Use was successfully created"
        redirect_to :action => :index
      else
        render :action => :new
      end
    end
  end

  form :html =>{:class => "customForm"} do |f|
    f.inputs do
      f.input :description, :label => "Add Photo/Video Use"
    end
    f.actions
  end

  member_action :delete_use do
    use = Use.find(params[:id])
    use.update_attribute(:is_deleted, true)
    redirect_to admin_uses_path, :notice => "Use deleted Successfully !!!"
  end
end
