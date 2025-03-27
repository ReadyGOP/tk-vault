local k = import 'k.libsonnet';
local envVar = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/EnvironmentVariables.libsonnet';
local volM = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/VolumeMounts.libsonnet';
local vol = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/Volumes.libsonnet';

local ContainerInception(ci) = std.map(function(config)
  k.core.v1.container.new(config.name, config.image + config.tag) + {
    env+: envVar.setenv(config.env),
    command: config.command,
    resources: config.resources,
    volumeMounts+: volM.setvolM(config.volumeMounts),
  } + (if std.objectHas(config, 'ports') then {
      ports: [
        {
          containerPort: config.ports.containerPort,
        } + (if std.objectHas(config.ports, 'protocol') then { protocol: config.ports.protocol } else {}),
      ]
    } else {}),
  std.objectValues(ci)
);

local generateContainers(init, cont) = {
  spec+: {
    template+: {
      spec+: {
        initContainers: ContainerInception(init),
        containers: ContainerInception(cont),
      }
    }
  }
};

{
  generateContainers: generateContainers,
  ContainerInception: ContainerInception,
}