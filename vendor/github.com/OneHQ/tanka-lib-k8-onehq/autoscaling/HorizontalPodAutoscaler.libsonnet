local setHPA(values, name) = {
  spec+: {
    scaleTargetRef: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      name: name,
    },
    minReplicas: values.minReplicas,
    maxReplicas: values.maxReplicas,
    metrics: values.metrics,
    behavior: values.behavior,
  },
};

{
    setHPA: setHPA,
}