class Event < ActiveRecord::Base
  belongs_to :user
  has_many :patient_forms
  has_many :patients, :through => :patient_forms

  extend ApiHelper

  attr_accessible :event_date, :event_time, :is_permanent_event, :name, :user_id

  # Validations
  validates_uniqueness_of :name,:scope => [:is_permanent_event], :case_sensitive => false, if: lambda { |event| event.is_permanent_event }
  validates_uniqueness_of :name, :scope => [:event_date], :case_sensitive => false, unless: lambda { |event| event.is_permanent_event }
  validates :name, :user_id, :presence => true
  validates :event_date, :presence => true, :if => :not_permanent_event
  validate :valid_permanent_event_field
  validate :valid_event_date

  before_validation :change_event_date_formate, :if => :not_permanent_event

  def self.create_event params
    event_params = json_parse params['event']
    user = User.select("id").find_by_id(event_params[:user_id])
    return {status: false, message: "User not found"} if user.nil?
    event = user.events.create(event_params)
    event.event_date = event.event_date.to_s
    event.errors.any? ? {status: false, message: event.errors.full_messages.join(", ")} : {status: true, message: "Event is successfully created", event: event}
  end

  def self.generate_pdf params
    @patient_form = PatientForm.find(params[:patient_form_id])
    use_ids = @patient_form.patient_form_uses.pluck(:use_id)
    @uses = []
    use_ids.each do |u|
      @uses << Use.find(u).description
    end
    @uses <<  @patient_form.other_purpose if @patient_form.other_purpose.present?
    release_form = ReleaseForm.new(@patient_form, @uses, @patient_form.profile_image, @patient_form.sign_image)
    return release_form, @patient_form.id
  end

  def not_permanent_event
    !is_permanent_event
  end

  def valid_event_date
    errors.add(:event_date, "is invalid") if event_date.present? && event_date < Date.today
  end

  def valid_permanent_event_field
    errors.add(:is_permanent_event, "must be a boolean value") unless [true, false].include?(is_permanent_event)
  end

  def change_event_date_formate
    self.event_date = DateTime.strptime(self.event_date_before_type_cast,'%m-%d-%Y') if self.event_date_before_type_cast.present?
  end
end
