local setPDB(values, name) = {
  spec+: {
    minAvailable: values.minAvailable,
    maxUnavailable: values.maxUnavailable,
    selector: values.selector
  }
};

{
    setPDB: setPDB,
}