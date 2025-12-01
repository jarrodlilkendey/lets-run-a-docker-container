terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "=2.68.0"
    }
  }
}

provider "digitalocean" {
  token = var.DIGITAL_OCEAN_TOKEN
}

variable "DIGITAL_OCEAN_TOKEN" {
  type = string
  sensitive = true
}

variable "DIGITAL_OCEAN_APP_NAME" {
  type = string
}

variable "DIGITAL_OCEAN_REGION_SLUG" {
  type = string
}

variable "ALERT_EMAIL_DESTINATION" {
  type = string
  sensitive = true
}

resource "digitalocean_app" "custom_app_github" {
  spec {
    name                    = var.DIGITAL_OCEAN_APP_NAME
    region                  = var.DIGITAL_OCEAN_REGION_SLUG

    service {
      name                  = "selfheal-service"
      instance_count        = 1
      instance_size_slug    = "apps-s-1vcpu-0.5gb"
      http_port             = 8080
      dockerfile_path       = "applications/nodejs-express-rest-api/Dockerfile"

      git {
        repo_clone_url      = "https://github.com/jarrodlilkendey/lets-run-a-docker-container.git"
        branch              = "master"
      }

      env {
        key                 = "PORT"
        value               = "8080"
      }

      health_check {
        http_path           = "/health"
      }
      
      alert {
        rule     = "RESTART_COUNT"
        value    = 2
        operator = "GREATER_THAN"
        window   = "TEN_MINUTES"
        disabled = false

        destinations {
          emails = [var.ALERT_EMAIL_DESTINATION]
        }
      }
    }
  }
}

output "digitalocean_custom_app_github_live_url" {
  value                     = digitalocean_app.custom_app_github.live_url
}