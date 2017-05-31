module Core::ActivityLogHelper
	NOTABLE_NAME = {"project_log" => 'Project Name', "lead_log" => "Lead Name"}
	def get_filter_options
		if params[:action] == "invoice_log"
			{
		        filter_box: [		      
		            {key: :user, label: 'Created By'},
		            {key: :auditable_invoice_on_name, label: "Invoice For"}
		        ],
		        filter_aggregates: [

		        ]
      		}
		else
			{
		        filter_box: [		           
		            {key: :user, label: 'Posted By'},
		            {key: :notable_name, label: NOTABLE_NAME[params[:action]]},
		            {key: :content, label: 'Text Content'}   

		        ],
		        filter_aggregates: [

		        ]
      		}
      	end
	end
end
