# GCP Recommendations Checker

This Terraform deploys a CloudFunction to use Recommender API across the GCP Org, Folders and Projects

## Required Service Account Permission to deploy solution

Organization Admin permission (`roles/resourcemanager.organizationAdmin`) is required for terraform execution.

## Required SA permissions to collect recommendations on Organization levels

### Mandatory roles

- `roles/cloudasset.viewer`
- `roles/recommender.computeViewer`
- `roles/recommender.cloudsqlViewer`
- `roles/recommender.cloudAssetInsightsViewer`
- `roles/recommender.billingAccountCudViewer`
- `roles/recommender.ucsViewer`
- `roles/recommender.projectCudViewer`

### Optional roles for Recommenders

- `roles/recommender.productSuggestionViewer`
- `roles/recommender.firewallViewer`
- `roles/recommender.errorReportingViewer`
- `roles/recommender.dataflowDiagnosticsViewer`
- `roles/recommender.containerDiagnosisViewer`
- `roles/recommender.iamViewer`

## Supported Recommenders

- `google.compute.instance.IdleResourceRecommender`                - idle VM's
- `google.compute.image.IdleResourceRecommender`                   - idle GCE custom imgages
- `google.compute.address.IdleResourceRecommender`                 - idle IP adresses
- `google.compute.disk.IdleResourceRecommender`                    - idle GCE disks
- `google.cloudsql.instance.IdleRecommender`                       - idle SQL instances
- `google.cloudsql.instance.OverprovisionedRecommender`            - rightsized SQL instances
- `google.cloudsql.instance.OverprovisionedRecommender`            - rightsized VM instances
- `google.cloudbilling.commitment.SpendBasedCommitmentRecommender` - spent based cost saver
- `google.compute.commitment.UsageCommitmentRecommender`           - usage based cost saver

## WIP

- `datastore collections to store recommendation` - Simple NoSQ Document DB to collect and store recommendations
- `resources filters per org_id, folder_id, project_id` - pre-defined serch queries to filter recommendations

## Input Variables

| Name                          | Description                                   | Type   | Default           | Required |
|:--------------------------------|:--------------------------------------------|:-------|:------------------|:---------|
| organization_id                 | GCP Organization ID                         | string | ""                | yes      |
| gcp_project                     | GCP Project ID to deploy the Cloud Function | string | ""                | yes      |
| gcp_region                      | GCP Region to deploy                        | string | "us-central1"     | yes      |
| bucket_name                     | GCS bucket to manage Cloud Function codes   | string | ""                | yes      |
| slack_webhook_url               | Slack Webhook URL to notify results         | string | ""                | yes      |
| job_schedule                    | Cron expression for periodic execution      | string | "0 */8* **"       | no       |
| job_timezone                    | Timezone                                    | string | "Etc/GMT"         | no       |
| idle_vm_recommender_enabled     | Option to enable Idle VM Recommender        | string | true              | no       |
| idle_sql_recommender_enabled    | Option to enable Idle SQL Recommender       | string | true              | no       |
| idle_disk_recommender_enabled   | Option to enable Idle SQL Recommender       | string | true              | no       |
| idle_image_recommender_enabled  | Option to enable Idle SQL Recommender       | string | true              | no       |
| idle_ip_recommender_enabled     | Option to enable Idle SQL Recommender       | string | true              | no       |

## Use Service Account to Autorize to client GCP Organization

    export CLIENT_ORG_ID = ""
    export $PROJECT_ID = "" # authorized service account project

### Add required roles for recommender SA

    gcloud organizations add-iam-policy-binding $CLIENT_ORG_ID \
       --member="serviceAccount:organization-checker@y#$PROJECT_ID.iam.gserviceaccount.com" \
       --role="roles/recommender.cloudAssetInsightsViewer" \
       --role="roles/recommender.computeViewer \
       --role="roles/recommender.cloudsqlViewer" \
       --role="roles/recommender.billingAccountCudViewer" \
       --role="roles/recommender.ucsViewerr" \
       --role="roles/recommender.projectCudViewer" \
