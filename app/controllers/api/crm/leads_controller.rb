class Api::Crm::LeadsController < Api::ApiController

  def create
    puts '#############################################'
    puts '#############################################'
    puts 'In Create Method'
    @lead = Crm::Lead.new(leads_params)
    @lead.source = params[:crm_lead][:source]
    @lead.user = Core::EmbeddedUser.find_by_username('system_user')
    @lead.organization_unit = params[:crm_lead][:org_unit]
    puts @lead.inspect
    puts '#############################################'
    puts '#############################################'
    @lead.save(validate: false)
    render nothing: true
  end

  def leads_params
    organization_unit = Core::OrganizationUnit.find_by(title: params[:crm_lead][:org_unit])
    source = Core::Source.find_by(name: params[:crm_lead][:source])
    params[:crm_lead][:org_unit] = organization_unit
    params[:crm_lead][:source] = source
    params.require(:crm_lead)
    .permit(:first_name, :last_name, :email, :phone, :description
    )
  end

  def split_name
    unless params[:name].nil?
      splitted_name = params[:name].split(' ')
      first_name = splitted_name.first
      splitted_name.shift
      last_name = splitted_name.join(' ')
      [first_name, last_name]
    end
  end
end