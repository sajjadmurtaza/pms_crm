module Workspace::AuditsHelper
  def separate_notes(klass=nil, audits)
    return audits if klass.nil?
    separated_audits = []
    audits.each do |audit|
      if audit.audited_changes['notable_type'] == klass
        separated_audits.push(audit)
      end
    end
    separated_audits
  end
end
