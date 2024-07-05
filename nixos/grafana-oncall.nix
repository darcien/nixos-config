# Auto-generated using compose2nix v0.2.0-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      # Required for container networking to be able to use names.
      dns_enabled = true;
    };
  };
  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."oncall-celery" = {
    image = "grafana/oncall";
    environment = {
      BASE_URL = "http://localhost:8888";
      BROKER_TYPE = "redis";
      CELERY_WORKER_BEAT_ENABLED = "True";
      CELERY_WORKER_CONCURRENCY = "1";
      CELERY_WORKER_MAX_TASKS_PER_CHILD = "100";
      CELERY_WORKER_QUEUE = "default,critical,long,slack,telegram,webhook,retry,celery,grafana";
      CELERY_WORKER_SHUTDOWN_INTERVAL = "65m";
      DATABASE_TYPE = "sqlite3";
      DJANGO_SETTINGS_MODULE = "settings.hobby";
      FEATURE_PROMETHEUS_EXPORTER_ENABLED = "false";
      GRAFANA_API_URL = "http://grafana:3333";
      PROMETHEUS_EXPORTER_SECRET = "";
      REDIS_URI = "redis://redis:6379/0";
      SECRET_KEY = "my_random_secret_must_be_more_than_32_characters_long";
    };
    volumes = [
      "oncall_oncall_data:/var/lib/oncall:rw"
    ];
    cmd = [ "sh" "-c" "./celery_with_exporter.sh" ];
    dependsOn = [
      "oncall-oncall_db_migration"
      "oncall-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=celery"
      "--network=oncall_default"
    ];
  };
  systemd.services."podman-oncall-celery" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    requires = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    partOf = [
      "podman-compose-oncall-root.target"
    ];
    wantedBy = [
      "podman-compose-oncall-root.target"
    ];
  };
  virtualisation.oci-containers.containers."oncall-engine" = {
    image = "grafana/oncall";
    environment = {
      BASE_URL = "http://localhost:8888";
      BROKER_TYPE = "redis";
      CELERY_WORKER_BEAT_ENABLED = "True";
      CELERY_WORKER_CONCURRENCY = "1";
      CELERY_WORKER_MAX_TASKS_PER_CHILD = "100";
      CELERY_WORKER_QUEUE = "default,critical,long,slack,telegram,webhook,retry,celery,grafana";
      CELERY_WORKER_SHUTDOWN_INTERVAL = "65m";
      DATABASE_TYPE = "sqlite3";
      DJANGO_SETTINGS_MODULE = "settings.hobby";
      FEATURE_PROMETHEUS_EXPORTER_ENABLED = "false";
      GRAFANA_API_URL = "http://grafana:3333";
      PROMETHEUS_EXPORTER_SECRET = "";
      REDIS_URI = "redis://redis:6379/0";
      SECRET_KEY = "my_random_secret_must_be_more_than_32_characters_long";
    };
    volumes = [
      "oncall_oncall_data:/var/lib/oncall:rw"
    ];
    ports = [
      "8888:8888/tcp"
    ];
    cmd = [ "sh" "-c" "uwsgi --ini uwsgi.ini" ];
    dependsOn = [
      "oncall-oncall_db_migration"
      "oncall-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=engine"
      "--network=oncall_default"
    ];
  };
  systemd.services."podman-oncall-engine" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    requires = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    partOf = [
      "podman-compose-oncall-root.target"
    ];
    wantedBy = [
      "podman-compose-oncall-root.target"
    ];
  };
  virtualisation.oci-containers.containers."oncall-oncall_db_migration" = {
    image = "grafana/oncall";
    environment = {
      BASE_URL = "http://localhost:8888";
      BROKER_TYPE = "redis";
      CELERY_WORKER_BEAT_ENABLED = "True";
      CELERY_WORKER_CONCURRENCY = "1";
      CELERY_WORKER_MAX_TASKS_PER_CHILD = "100";
      CELERY_WORKER_QUEUE = "default,critical,long,slack,telegram,webhook,retry,celery,grafana";
      CELERY_WORKER_SHUTDOWN_INTERVAL = "65m";
      DATABASE_TYPE = "sqlite3";
      DJANGO_SETTINGS_MODULE = "settings.hobby";
      FEATURE_PROMETHEUS_EXPORTER_ENABLED = "false";
      GRAFANA_API_URL = "http://grafana:3333";
      PROMETHEUS_EXPORTER_SECRET = "";
      REDIS_URI = "redis://redis:6379/0";
      SECRET_KEY = "my_random_secret_must_be_more_than_32_characters_long";
    };
    volumes = [
      "oncall_oncall_data:/var/lib/oncall:rw"
    ];
    cmd = [ "python" "manage.py" "migrate" "--noinput" ];
    dependsOn = [
      "oncall-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=oncall_db_migration"
      "--network=oncall_default"
    ];
  };
  systemd.services."podman-oncall-oncall_db_migration" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    requires = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_oncall_data.service"
    ];
    partOf = [
      "podman-compose-oncall-root.target"
    ];
    wantedBy = [
      "podman-compose-oncall-root.target"
    ];
  };
  virtualisation.oci-containers.containers."oncall-redis" = {
    image = "redis:7.0.5";
    volumes = [
      "oncall_redis_data:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      # "--cpu-quota=0.5"
      "--cpus=0.5"
      "--health-cmd=[\"redis-cli\",\"ping\"]"
      "--health-interval=5s"
      "--health-retries=10"
      "--health-timeout=5s"
      "--memory=524288000b"
      "--network-alias=redis"
      "--network=oncall_default"
    ];
  };
  systemd.services."podman-oncall-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_redis_data.service"
    ];
    requires = [
      "podman-network-oncall_default.service"
      "podman-volume-oncall_redis_data.service"
    ];
    partOf = [
      "podman-compose-oncall-root.target"
    ];
    wantedBy = [
      "podman-compose-oncall-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-oncall_default" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f oncall_default";
    };
    script = ''
      podman network inspect oncall_default || podman network create oncall_default
    '';
    partOf = [ "podman-compose-oncall-root.target" ];
    wantedBy = [ "podman-compose-oncall-root.target" ];
  };

  # Volumes
  systemd.services."podman-volume-oncall_oncall_data" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect oncall_oncall_data || podman volume create oncall_oncall_data
    '';
    partOf = [ "podman-compose-oncall-root.target" ];
    wantedBy = [ "podman-compose-oncall-root.target" ];
  };
  systemd.services."podman-volume-oncall_redis_data" = {
    path = [ pkgs.podman ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect oncall_redis_data || podman volume create oncall_redis_data
    '';
    partOf = [ "podman-compose-oncall-root.target" ];
    wantedBy = [ "podman-compose-oncall-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-oncall-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
