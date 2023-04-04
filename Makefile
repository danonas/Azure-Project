westeurope:
    terraform workspace new  westeurope  || terraform workspace select  westeurope
    terraform init  
    terraform apply -var-file westeurope.tfvars -auto-approve


uksouth:
		terraform workspace new  uksouth  || terraform workspace select  uksouth
		terraform init  
		terraform apply -var-file envs/uksouth.tfvars -auto-approve


africanorth:
		terraform workspace new  africanorth  || terraform workspace select  africanorth
		terraform init  
		terraform apply -var-file envs/africanorth.tfvars -auto-approve


canadaeast:
		terraform workspace new  canadaeast  || terraform workspace select  canadaeast
		terraform init  
		terraform apply -var-file envs/canadaeast.tfvars -auto-approve


norwayeast:
		terraform workspace new  norwayeast  || terraform workspace select  norwayeast
		terraform init   
		terraform apply -var-file envs/norwayeast.tfvars -auto-approve				  
##########################################################################################

westeurope-destroy:
    terraform workspace new  westeurope  || terraform workspace select  westeurope
    terraform init  
    terraform destroy -var-file westeurope.tfvars -auto-approve

uksouth-destroy:
		terraform workspace select  uksouth
		terraform init    
		terraform destroy -var-file envs/uksouth.tfvars -auto-approve

africanorth-destroy:
		terraform workspace select  africanorth
		terraform init  
		terraform destroy -var-file envs/africanorth.tfvars -auto-approve 		 

canadaeast-destroy:
		terraform workspace select  canadaeast
		terraform init    
		terraform destroy -var-file envs/canadaeast.tfvars -auto-approve
		
norwayeast-destroy:
		terraform workspace select  norwayeast
		terraform init  
		terraform destroy -var-file envs/norwayeast.tfvars -auto-approve 
