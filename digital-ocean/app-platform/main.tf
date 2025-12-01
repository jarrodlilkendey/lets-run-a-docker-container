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

resource "digitalocean_app" "nginx" {
  spec {
    name                    = var.DIGITAL_OCEAN_APP_NAME
    region                  = var.DIGITAL_OCEAN_REGION_SLUG

    service {
      name                  = "nginx-service"
      instance_count        = 1
      instance_size_slug    = "apps-s-1vcpu-0.5gb"
      http_port             = 80

      image {
        registry_type = "DOCKER_HUB"
        registry = "library"
        repository = "nginx"
        tag = "latest"
      }
    }
  }
}

output "digitalocean_nginx_live_url" {
  value       = digitalocean_app.nginx.live_url
}