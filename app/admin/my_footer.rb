class MyFooter < ActiveAdmin::Component
  def build
    super(id: "footer")
    para "Copyright 2013. CHOC Admin"
  end
end
