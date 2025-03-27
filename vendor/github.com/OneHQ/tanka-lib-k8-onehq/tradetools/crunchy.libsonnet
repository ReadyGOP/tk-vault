local crunchydb(config) = {
  apiVersion: "postgres-operator.crunchydata.com/v1beta1",
  kind: "PostgresCluster",
  metadata: {
    name: config.clusterName,
    annotations: config.annotations,
  },
  spec: {
    postgresVersion: config.postgresVersion,
    users: config.users,
    dataSource: config.dataSource,
    instances: [
      {
        name: config.instances.name,
        replicas: config.instances.replicas,
        resources: config.instances.resources,
        dataVolumeClaimSpec: config.instances.dataVolumeClaimSpec,
        affinity: config.instances.affinity,
        tolerations: config.instances.tolerations,
      },
    ],
    patroni: config.patroni,
    backups: config.backups,
    proxy: config.proxy,
  },
};
{
    crunchydb: crunchydb,
}