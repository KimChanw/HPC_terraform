# 이 코드는 Terraform 4.25.0 및 4.25.0과(와) 하위 호환되는 버전과 호환됩니다.
# 이 Terraform 코드를 검증하는 방법은 https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build#format-and-validate-the-configuration을 참조하세요.

resource "google_compute_instance" "instance-2" {
  boot_disk {
    auto_delete = true

    initialize_params {
      image = "projects/centos-cloud/global/images/centos-7-v20231115"
      size  = 30
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "e2-medium"
  count = 3
  name = "pbsnode${count.index+1}"

  network_interface {
    subnetwork = var.subnet
    network_ip = "192.168.43.1${count.index}"
  }

  scheduling {
    automatic_restart = false
    preemptible = true
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  zone = "us-west2-a"
}
