provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = "us-west2"
}