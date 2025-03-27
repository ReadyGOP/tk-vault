local k = import 'k.libsonnet';

local setvolM(volm) = std.map(
  function(key)
    k.core.v1.volumeMount.new(name=key.name, mountPath=key.mountPath, readOnly=key.readOnly),
  volm
);

{
  setvolM: setvolM,
}