terraform {
  backend "gcs" {
    bucket = "finops-demo-tf-state-gcs"
    prefix = "admin/recommender/org-checker"
  }
}
