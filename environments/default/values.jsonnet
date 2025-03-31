local here = import 'values.jsonnet';

{

    ns: 'test',

    dockerHubSecretName: 'secrets-dockerhub-readygop-private',
    dockerHubSecret: "PGRvY2tlcj4=",

    redis: {
        labels: {
        app: 'redis',
        },
        replicas: 1,
        serviceName: 'redis-svc',
        spec: {
            saName: '',
            serviceName: 'redis-svc',
            volumes: [],
            initC: {},
            cont: {
                redis:{
                name: here.redis.labels.app,
                image: 'redis:',
                tag: '7.4-rc2-alpine',
                command: [],
                resources: {
                    limits: {
                    cpu: 1,
                    memory: '2Gi',
                    },
                    requests: {
                    cpu: '500m',
                    memory: '1Gi',
                    },
                },
                volumeMounts: [{ mountPath: '/data', name: 'redis-data', readOnly: false }],
                env: {
                    configMaps: [
                        [self.cmName, self.cmURL],
                    ],
                    cmName: 'redis-url',
                    cmURL: {
                        REDIS_URL: 'redis://redis-svc-' + here.ns + '.svc.cluster.local:6379',
                    },
                    secretRefs: [
                        [self.secretDockerName, self.secretDocker],
                    ],

                    secretDockerName: 'secrets-token-docker',
                    secretDocker: {
                        TOKEN: here.dockerHubSecret
                    },
                    keyvalue: []
                },
                port: {
                    containerPort: '6379',
                    protocol: 'TCP',
                },
                }  
            },
            volumeClaimTemplates: [{
                name: 'redis-data',
                accessModes: ['ReadWriteOnce'],
                storageClassName: 'crc-csi-hostpath-provisioner',
                storage: '1Gi',
            }],
        },
        svc_ports: [{ port: 6379, targetPort: 6379, protocol: 'TCP' }],
    },

    


}
