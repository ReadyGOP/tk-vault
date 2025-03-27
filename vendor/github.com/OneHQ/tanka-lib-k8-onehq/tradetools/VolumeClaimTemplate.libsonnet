local generateVolumeClaimTemplates(vclaim) =
  if std.length(vclaim) == 0 then []
  else std.map(
    function(key)
      {
        metadata: { name: key.name},
        spec: {
          accessModes: key.accessModes,
          storageClassName: key.storageClassName,
          resources: {
            requests: {
              storage: key.storage,
            },
          },
        },
      },
    vclaim
  );

{
  generateVolumeClaimTemplates: generateVolumeClaimTemplates,
}