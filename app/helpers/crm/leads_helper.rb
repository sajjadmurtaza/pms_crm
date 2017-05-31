module Crm::LeadsHelper
  def lead_audits(lead)

    ######### Collection of all Audits related to current lead ########
    @audit = lead.audits

    ######### Sorting array of audits in descending order w.r.t to time attribute (created_at) ########
    @audit = @audit.sort_by{|e| e[:created_at]}.reverse

    return @audit
  end

end
