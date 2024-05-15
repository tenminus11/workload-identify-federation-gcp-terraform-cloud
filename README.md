# Keyless Google Cloud Access from HCP Terraform
Securely access Google Cloud from HCP Terraform using Google's Workload Identity Federation, eliminating the need for storing service account keys.

## What is identity federation?
Identity federation lets HCP Terraform impersonate a service account through its native OpenID Connect integration and obtain a short-lived OAuth 2.0 access token. This short-lived access token lets you call any Google Cloud APIs that the service account has access to at runtime, making your HCP Terraform runs much more secure.

## Using Workload Identity Federation
Using HashiCorp Terraform, you have the ability to create a Workload Identity [Pool](https://cloud.google.com/iam/docs/workload-identity-federation#pools) and [Provider](https://cloud.google.com/iam/docs/workload-identity-federation#providers), which HCP Terraform uses to request a federated token from. This token is then passed to the Google Terraform provider, which impersonates a service account to obtain temporary credentials to plan or apply Terraform with.

## Steps for succesful deployment: 
1. For initial setup create a temporary Service Account with the editor role. This Service Account will be used to connect Terraform Cloud to Google Cloud. Don't forget to remove this Service Accounce once Workload Identity Federation has been setup. 
2. Add the Service Account JSON key to Terraform Cloud as a sensitive variable.
3. We now have a connection between Terraform Cloud and Google Cloud, now we can use the setup-wif script to create a Workload Identity Pool and Provider with Terraform.
4. First make sure to adjust the local variables in the wif.tf Terraform plan to match your environment.
5. Let's run the plan which will set up the workload identity pool and provider, and create a Service Account with Terraform that HCP Terraform will impersonate at runtime 
6. Once the plan has been applied, we can now use the impersonated service account to run Terraform plans and applies with Google Workload Identity Federation. 
7. We can run the Terraform plan in use-wif folder to create a test resource in our Google Cloud project. A new short lived access token will be created for each run.
8. Don't forget to remove the temporary Service Account that was used to initial connect Terraform Cloud to Google Cloud.

Please reach out to me if you have any questions.