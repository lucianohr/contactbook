class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  require 'jasper_report'

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def report
    data = Contact.all.map{|c| c.instance_values["attributes"]}
    respond_to_report('contacts', 'contacts.pdf', data, false)
  end

  def gantt
    data = (1..50).map do |idx|
      {
        name: "Task #{idx}", 
        prevision_start: Date.today + idx.days, 
        prevision_end: Date.today + 10.days + idx.days,
        date_start: Date.today + idx.days, 
        date_end: Date.today + 10.days + idx.days,
        subtasks: [
          {
            name: "Subtask 1", 
            prevision_start: Date.today + idx.days, 
            prevision_end: Date.today + 10.days + idx.days,
            date_start: Date.today + idx.days, 
            date_end: Date.today + 10.days + idx.days
          },
          {
            name: "Subtask 2", 
            prevision_start: Date.today + idx.days, 
            prevision_end: Date.today + 10.days + idx.days,
            date_start: Date.today + idx.days, 
            date_end: Date.today + 10.days + idx.days
          },
          {
            name: "Subtask 3", 
            prevision_start: Date.today + idx.days, 
            prevision_end: Date.today + 10.days + idx.days,
            date_start: Date.today + idx.days, 
            date_end: Date.today + 10.days + idx.days
          }
        ]
      }
    end
    respond_to_report('gantt', 'gantt.pdf', data, false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :address, :city, :phone, :email)
    end
end
