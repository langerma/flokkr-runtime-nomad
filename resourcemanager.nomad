job "resourcemanager" {
  datacenters = [
    "dc1"
  ]

  type = "service"

  group "resourcemanager" {
    count = 1
    ephemeral_disk {
      migrate = true
      size = "1024"
      sticky = true
    }
    task "resourcemanager" {
      driver = "docker"
      config {
        image = "flokkr/hadoop-yarn-resourcemanager:3.0.0-beta1-RC0"
        network_mode = "host"
        force_pull = true
        volumes = [
          "local/data:/data"
        ]
        #{include "logging.nomad"}#
      }
      service {
        name = "resourcemanager"
        port = "rpc"
      }

      env {
        CONFIG_TYPE = "consul"
        CONSUL_KEY = "yarn"
        HADOOP_LOG_DIR = "/tmp"
      }
      resources {
        cpu = 500
        memory = 2001
        network {
          port "rpc" {}
        }
      }
    }
  }
}
