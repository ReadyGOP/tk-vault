local k = import 'k.libsonnet';
local kone = import 'k8-onehq.libsonnet';
# Values
local values = import 'values.jsonnet';
local here = import 'main.jsonnet';

{
    ns: k.core.v1.namespace.new(values.ns),

    // Redis resources.
###########################################################################################################################
  // Redis ConfigMap for url.
  redisCM_URL: k.core.v1.configMap.new(values.redis.spec.cont.redis.env.cmName, values.redis.spec.cont.redis.env.cmURL),
  // Redis StatefulSet.
  redisSS: k.apps.v1.statefulSet.new(values.redis.labels.app) + kone.createSS(values.redis.spec, values.redis.labels.app),
  // Redis Service.
  redisService: k.core.v1.service.new(values.redis.serviceName, values.redis.labels, values.redis.svc_ports),

  // Docker Registry Secret.
  dockerHubSecret: k.core.v1.secret.new(values.dockerHubSecretName, { 
      ".dockerconfigjson": values.dockerHubSecret
  }, type="kubernetes.io/dockerconfigjson") + {
    metadata+: {
      annotations: {
        "avp.kubernetes.io/path": "secret/data/repo"
      }
    }
  }, 
  
}
