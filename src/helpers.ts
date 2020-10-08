export function loadPackage(packageName: string): any {
  try {
    return require(packageName);
  } catch (err) {
    return null;
  }
}
