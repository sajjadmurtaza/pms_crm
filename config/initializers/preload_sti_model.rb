if Rails.env.development?
  %w[phone_type email_type].each do |c|
    require_dependency File.join('app','models','core',"#{c}.rb")
  end
end