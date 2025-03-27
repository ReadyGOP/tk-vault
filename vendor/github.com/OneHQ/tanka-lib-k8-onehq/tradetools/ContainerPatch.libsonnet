local containerPatch = function(
  newDeployName,
  newLabels,
  source_containerName,
  newValues,
  baseDeployment)
baseDeployment + {
  metadata+: {
    name: newDeployName,
  },
  spec+: {
    selector+: {
      matchLabels: newLabels,
    },
    template+: {
      metadata+: {
        labels: newLabels,
      },
      spec+: {
        containers: std.map(
          function(c)
            if c.name == source_containerName then
              c + {
                name: newDeployName,
                command: newValues.command,
                resources: newValues.resources,
                env+: newValues.env,
                volumeMounts: newValues.volumeMounts,
              }
            else c,
          baseDeployment.spec.template.spec.containers
        ),
      },
    },
  },
};

{
    containerPatch: containerPatch,
}