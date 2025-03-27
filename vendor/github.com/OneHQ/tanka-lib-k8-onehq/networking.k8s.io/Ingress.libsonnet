local set_hosts(host, svc_name, port) = {
    host: host,
    http: {
      paths: [
        {
          path: '/',
          pathType: 'Prefix',
          backend: {
            service: {
              name: svc_name,
              port: {
                number: port,
              }
            },
          },
        },
      ],
    },
};

local createIngress(hosts, svc_name, port, class, annotations) = {
  metadata+: {
    annotations: annotations,
    labels:{
      ingressClassName: class,
    },
  },
  spec+: {
    ingressClassName: class,
    rules: std.flattenArrays([
      std.map(function(key)
        set_hosts(key, svc_name, port),
        hosts,
      ),
    ]),
  },
};

{
    createIngress: createIngress,
    set_hosts: set_hosts,
}