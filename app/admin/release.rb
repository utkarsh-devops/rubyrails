ActiveAdmin.register Release do
  menu :priority => 3
  actions :all, except: [:destroy]
  config.clear_action_items!
  config.filters = false

  index do
    panel raw("Current Release &nbsp;&nbsp;#{link_to("Edit",edit_release_admin_release_path(Release.last.id))}") do
      Release.last.english_desc.html_safe
    end
  end

  member_action :edit_release, :method => :get do
    @release = Release.find(params[:id])
  end

  collection_action :update_release, :method => :post do
    if Release.last.english_desc != params[:release][:english_desc] || Release.last.spanish_desc != params[:release][:spanish_desc]
      version = Release.last.version + 1
      english_desc = Release.last.english_desc != params[:release][:english_desc] ? params[:release][:english_desc] : Release.last.english_desc
      spanish_desc = Release.last.spanish_desc != params[:release][:spanish_desc] ? params[:release][:spanish_desc] : Release.last.spanish_desc
      Release.create!(:version => version, :english_desc => english_desc, :spanish_desc => spanish_desc)
      redirect_to admin_releases_path, :notice => "Release Form changed successfully !!!"
    else
      redirect_to admin_releases_path, :notice => "You are not change anything in the release form."
    end
  end
end