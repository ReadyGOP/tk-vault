local k = import 'k.libsonnet';
local Containers = import 'github.com/OneHQ/tanka-lib-k8-onehq/core/Container.libsonnet';
local setvol = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/Volumes.libsonnet';
local vclaim = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/VolumeClaimTemplate.libsonnet';

local createSS(values, name) = {
  spec+: {
    selector: {
      matchLabels: {app: name},
    },
    serviceName: values.serviceName,
    template: {
      metadata: { labels: {app: name} },
      spec+: {
        serviceAccountName: values.saName,
        serviceAccount: values.saName,
        volumes: setvol.setvol(values.volumes),
      } 
      + (if std.objectHas(values, "registrySecretName") then {
          imagePullSecrets: [k.core.v1.localObjectReference.withName(values.registrySecretName)],
      } else {})
      + Containers.generateContainers(values.initC, values.cont).spec.template.spec,
    },
    volumeClaimTemplates: vclaim.generateVolumeClaimTemplates(values.volumeClaimTemplates),
  },
};

{
  createSS: createSS,
}