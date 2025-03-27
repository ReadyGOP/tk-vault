local k = import 'k.libsonnet';

local generateServices(values) = std.map(function(service)
  k.core.v1.service.new(
    name=service.name,
    selector=service.selector,
    ports=service.ports
  ),
  values.services
);

{
  generateServices: generateServices,
}