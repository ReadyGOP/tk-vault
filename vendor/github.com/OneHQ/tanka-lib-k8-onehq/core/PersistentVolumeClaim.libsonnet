local createPVC(values) = {
    spec+: {
      accessModes: values.accessModes,
      resources: {
        requests: {
          storage: values.storageSize,
        },
      },
      storageClassName: values.storageClass,
    },
};
{
    createPVC: createPVC,
}