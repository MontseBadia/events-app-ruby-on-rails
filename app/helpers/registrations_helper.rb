module RegistrationsHelper

  def show_register_link(event)
    if event.sold_out?
      content_tag(:strong, "Sould Out!")
    else 
      link_to 'Register', new_event_registration_path(@event), class: "button ok register"
    end
  end

end
