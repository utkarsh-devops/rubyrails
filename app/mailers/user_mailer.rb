class UserMailer < ActionMailer::Base
  default from: '"CHOC" <no-reply@choc.com>'

  def make_admin_mail user
    @user = user
    mail(to: user.email, subject: "You are chosen as CHOC Admin")
  end

  def block_user_mail user
    @user = user
    mail(to: user.email, subject: "You are blocked by CHOC Admin")
  end

  def activate_user_mail user
    @user = user
    mail(to: user.email, subject: "You are now active as CHOC Admin")
  end

  def release_form_mail patient_form, email
    @patient_form = patient_form
    @email = email
    release_form, patient_form_id = Event.generate_pdf(:patient_form_id => patient_form.id)
    attachments["Release Form #{patient_form_id}.pdf"] = release_form.pdf
    mail(to: email, subject: "This is your requested release form")
  end

  def create_admin_mail email
    @email = email
    mail(to: email, subject: "Are you ready to become CHOC Admin?")
  end
end