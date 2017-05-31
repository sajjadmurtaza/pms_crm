namespace :heyday do

    require 'net/http'
    require 'uri'
    require 'json'
    desc 'Importing User Data into Database'
    task import_users: :environment do

        auth_req = Net::HTTP.post_form URI('http://nexthrm-dev.vteamslabs.com/web-service/'),
                            { "method" => "getAuthentication", "userName" => "mg@nexthrm.com", "userPassword" => "test" }

        json_auth_data = JSON.parse(auth_req.body)

        emp_data_req = Net::HTTP.post_form URI('http://nexthrm-dev.vteamslabs.com/web-service/'),
                            { "auth" => "#{json_auth_data["auth"]}", "method" => "getEmpDetails", "userName" => "mg@nexthrm.com" }

        json_emp_data = JSON.parse(emp_data_req.body)

        for i in 2..json_emp_data.count
          name = json_emp_data[i]["empDetails"]["name"]
          email = json_emp_data[i]["empDetails"]["email"]
          skype = json_emp_data[i]["empDetails"]["skype"]
          phone = json_emp_data[i]["empDetails"]["phone"]
          emp_id = json_emp_data[i]["empDetails"]["emp_id"]
          calling_name = json_emp_data[i]["empDetails"]["calling_name"]
          designation = json_emp_data[i]["empDetails"]["designation"]
          join_date = json_emp_data[i]["empDetails"]["dt_nxb_join"]
          experience = json_emp_data[i]["empDetails"]["previous_total_experience"]
          emp_status = json_emp_data[i]["empDetails"]["employment_status"]

          if json_emp_data[i]["empDetails"]["designation"].present?
            job_title = Core::JobTitle.find_or_initialize_by(name: json_emp_data[i]["empDetails"]["designation"])
            if job_title.new_record?
              last_value = Core::JobTitle.last.value.to_i
              job_title.value = (last_value + 1).to_s
            end
          end


          if !Directory::UserDetail.exists?(emp_id: emp_id)
            user = Directory::User.new
            first_name = name.split(' ').first
            last_name = name.split(' ').second
            user.first_name = first_name.present? ? first_name : 'Not Specified'
            user.last_name = last_name.present? ? last_name : 'Not Specified'
            user.email = email.present? ? email : 'Not Specified'
            user.phone = phone.present? ? phone : 'Not Specified'
            user.set_default_picture
            user.save(validate:false)

            user_detail = Directory::UserDetail.new
            user_detail.user_id = user.id
            user_detail.calling_name = calling_name.present? ? calling_name : 'Not Specified'
            user_detail.emp_id = emp_id.present? ? emp_id : 'Not Specified'
            user_detail.experience = experience.present? ? experience : 'Not Specified'
            user_detail.appointment_date = join_date.present? ? join_date : 'Not Specified'
            user_detail.job_title = job_title
            user_detail.save(validate:false)

            puts '**************************************'
            puts 'User Saved Successfully'
            puts '**************************************'

          end
        end
      end
end
