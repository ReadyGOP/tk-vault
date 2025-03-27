# Example of a values in your project.
local tags = import 'staging-version.json'; // Contains the version of the image
local value = import 'staging-values.jsonnet'; // Call the same file so you can reuse values. For example the enviroments
{
  rails: {
    saName: 'sa-name',
    serviceName: 'serviceName',
    saRole: 'sarole',
    schedule: '*/1 * * * *',  # For cronjobs
    labels: {
        app: 'app-name',
      },
    restartPolicy: 'OnFailure',
    registrySecretName: 'registry-secret-name',
    dockerHubSecret: '', #in case the registry is DockerHub
    initC: {
      dbReady: {
        name: "db-ready-check",
        image: "postgres:16",
        command: ['/bin/sh', '-c', 
                  'until pg_isready -h $PGHOST -p $PGPORT -d $PGDATABASE -U $PGUSER; do
                      echo "Waiting for database readiness...";
                      sleep 5;
                    done'
                  ],
        resources: {},
        volumeMounts: [
          {
            name: 'example-env-secrets',
            mountPath: '/etc/secrets',
            readOnly: true,
          },
        ],
        env: {
          secretRefs: [
            [value.rails.cont.backend.env.railsUserSecretName, value.rails.cont.backend.env.railsUserSecrets],
          ],
          configMaps: [
            [value.rails.cont.backend.env.railsconfigMapsName, value.rails.cont.backend.env.railsconfigMaps],
          ],

          railsSecretName: 'main-db-pguser',
          railsSecrets: {
            PGUSER: 'user',
          },

          railsconfigMapsName: 'redis-url',
          railsconfigMaps: {
            REDIS_URL: 'redis-url',
          },
          keyvalue: [
            ['RAILS_ENV', 'development'],
            ['DBNAME', 'db-name'],
          ],

        },
      },
  },

  volumes: [
    {
      name: 'example-env-secrets',
      secret: {
        secretName: 'example-env-secrets',
      },
    },
  ],

  volumeClaimTemplates: [
    {
      name: 'example-volumeClaimTemplate',
      accessModes: ["ReadWriteOnce"],
      storageClassName: "storage-class-name",
      storage: "1Gi",
    },
  ],
  
  cont: {
    sidekiqDeploy: {
        name: "db-ready-check",
        image: "postgres:16",
        command: ['/bin/sh', '-c', 
                  'until pg_isready -h $PGHOST -p $PGPORT -d $PGDATABASE -U $PGUSER; do
                      echo "Waiting for database readiness...";
                      sleep 5;
                    done'
                  ],
        ports:
          {
            containerPort: 8080,
            protocol: "TCP",
          },
        resources: {},
        volumeMounts: [],
        env: {
          secretRefs: [
            [self.railsSecretName, self.railsSecrets],
          ],

          configMaps: [
            [self.railsconfigMapsName, self.railsconfigMaps],
          ],
          
          railsSecretName: 'main-db-pguser-maindb-admin-staging',
          railsSecrets: {
            PGUSER: 'user',
          },

          railsconfigMapsName: 'redis-url',
          railsconfigMaps: {
            REDIS_URL: 'redis-url',
          },
          keyvalue: [
            ['RAILS_ENV', 'development'],
            ['DBNAME', 'db-name'],
          ],
        },
    },
  },
 },
}