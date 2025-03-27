local here = import 'values.jsonnet';

{

    ns: 'test',

    dockerHubSecretName: 'secrets-dockerhub-readygop-private',
    dockerHubSecret: 'eyJhdXRocyI6eyJkb2NrZXIuaW8vcmVhZHlnb3AiOnsidXNlcm5hbWUiOiJqb3NlcGVjY2kiLCJwYXNzd29yZCI6ImRrckZFV0VSV2RlZTIzNGRld3IzMjNlZCIsImF1dGgiOiJhbTl6WlhCbFkyTnBPbVJyY2taRlYwVlNWMlJsWlRJek5HUmxkM0l6TWpObFpBPT0iLCJlbWFpbCI6IiJ9fX0=',



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
                secretRefs: [],
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
            storageClassName: 'basic',
            storage: '1Gi',
        }],
        },
        svc_ports: [{ port: 6379, targetPort: 6379, protocol: 'TCP' }],
    },


}