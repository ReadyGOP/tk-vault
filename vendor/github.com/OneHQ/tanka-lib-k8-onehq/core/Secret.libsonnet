local k = import 'k.libsonnet';

local generateSecrets(values) = std.map(function(secret)
  k.core.v1.secret.new(
    name=secret.name,
    data=secret.data,
    type=secret.type,
  ),
  values.secrets,
);

{
  generateSecrets: generateSecrets,
}