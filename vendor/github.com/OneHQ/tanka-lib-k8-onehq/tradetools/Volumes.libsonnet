local k = import 'k.libsonnet';

local setvol(vol) =
  if std.length(vol) == 0 then []
  else std.map(
    function(key)
      {
        name: key.name,
      } +
      if std.objectHas(key, 'claimName') then
        { persistentVolumeClaim: { claimName: key.claimName } }
      else if std.objectHas(key, 'emptyDir') then
        { emptyDir: key.emptyDir }
      else if std.objectHas(key, 'secret') then
        { secret: key.secret }
      else if std.objectHas(key, 'configMap') then
        { configMap: key.configMap }
      else {},
    vol
  );

{
  setvol: setvol,
}