local k = import 'k.libsonnet';

local setenv(values) = std.flattenArrays([
    if std.length(values.secretRefs) > 0 then
        std.flattenArrays(std.map(function(secretItem)
            if std.length(std.objectFields(secretItem[1])) > 0 then
                std.map(function(key)
                    if std.startsWith(secretItem[0], 'secrets-') then
                        k.core.v1.envVar.fromSecretRef(key, secretItem[0], key)
                    else 
                        k.core.v1.envVar.fromSecretRef(key, secretItem[0], secretItem[1][key]),
                std.objectFields(secretItem[1])
                )
            else [],
            values.secretRefs
        ))
    else [],
    if std.length(values.configMaps) > 0 then
        std.flattenArrays(std.map(function(configMapItem)
            if std.length(std.objectFields(configMapItem[1])) > 0 then
                std.map(function(key)
                  k.core.v1.envVar.withName(key) +
                  k.core.v1.envVar.valueFrom.configMapKeyRef.withName(configMapItem[0]) +
                  k.core.v1.envVar.valueFrom.configMapKeyRef.withKey(key),
                  std.objectFields(configMapItem[1]))
            else [],
            values.configMaps
        ))
    else [],
    if std.length(values.keyvalue) > 0 then
        std.map(function(item)
            k.core.v1.envVar.withName(item[0]) + k.core.v1.envVar.withValue(item[1]),
            values.keyvalue
        )
    else [],
]);

{
    setenv: setenv,
}