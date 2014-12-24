ActiveAdmin.register_page "Dashboard" do
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    upcoming_events = Event.select("id, name, event_date").where('is_permanent_event = ? && event_date >= ? ', false, Date.today).order("event_date ASC").limit(4)
    permanent_events = Event.select("id, name").where('is_permanent_event = ? ', true).order("created_at DESC").limit(4)

    columns do
      column do
        panel "Upcoming Events" do
          ul do
            upcoming_events.map do |e|
              if e.patient_forms.count > 0
                li raw("<a href='/admin/events/#{e.id}'><b>"+e.name+"</b></a><br>"+e.event_date.strftime("%B %d, %Y")+" Releases:("+e.patient_forms.count.to_s+")")
              else
                li raw("<b>"+e.name+"</b><br>"+e.event_date.strftime("%B %d, %Y")+" Releases:("+e.patient_forms.count.to_s+")")
              end
            end
          end
        end
      end

      column do
        panel "Permanent Events" do
          ul do
            permanent_events.map do |e|
              if e.patient_forms.count > 0
                li raw("<a href='/admin/events/#{e.id}'><b>"+e.name+"</b></a><br> Releases:("+e.patient_forms.count.to_s+")")
              else
                li raw("<b>"+e.name+"</b><br> Releases:("+e.patient_forms.count.to_s+")")
              end
            end
          end
        end
      end

      column do
        link_to(" + New Event ", new_admin_event_path, :class => 'button')
      end
    end
  end # content
end