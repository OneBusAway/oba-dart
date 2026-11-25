/// The local part of an OBA id (`<agencyId>_<localId>`): `1_75403` ->
/// `75403`, `MTS_24151` -> `24151`. Only the first underscore splits, so a
/// local part that contains `_` is kept whole. Ids without one are returned
/// unchanged.
String agencyLocalId(String id) {
  final i = id.indexOf('_');
  return i < 0 ? id : id.substring(i + 1);
}
