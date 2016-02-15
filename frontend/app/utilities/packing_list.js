export function packingListName(url) {
  const filenameIndex = url.lastIndexOf('/');
  let filename = url.substr(filenameIndex + 1);
  const queryIndex = filename.lastIndexOf('?');

  if (queryIndex !== -1) {
    filename = filename.substr(0, queryIndex);
  }

  return decodeURIComponent(filename);
}
