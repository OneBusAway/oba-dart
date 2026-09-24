class DemoStop {
  const DemoStop(this.id, this.label);

  final String id;
  final String label;
}

/// UCSD stops verified against realtime.sdmts.com on 2026-09-23.
const demoStops = [
  DemoStop('MTS_24151', 'Eighth College / Theatre District'),
  DemoStop('MTS_88986', 'UCSD Central Campus Trolley'),
  DemoStop('MTS_11902', 'Gilman Transit Center'),
];
