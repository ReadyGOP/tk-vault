local k = import 'k.libsonnet';
local Containers = import 'github.com/OneHQ/tanka-lib-k8-onehq/core/Container.libsonnet';
local setvol = import 'github.com/OneHQ/tanka-lib-k8-onehq/tradetools/Volumes.libsonnet';

local generateJob(values) = {
    spec+: {
        template: {
            metadata: {
                labels: values.labels,
            },
            spec+: {
                restartPolicy: values.restartPolicy,
                volumes: setvol.setvol(values.volumes),
            }
            + (if std.objectHas(values, "registrySecretName") then {
                imagePullSecrets: [k.core.v1.localObjectReference.withName(values.registrySecretName)],
            } else {}) 
            + Containers.generateContainers(values.initC, values.cont).spec.template.spec,
        },
    },
};

{
    generateJob: generateJob,
}