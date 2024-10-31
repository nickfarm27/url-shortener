export function parseShortenedUrl(path: string) {
  const { origin, host} = window.location
  const shortenedUrlWithOrigin = `${origin}/${path}`;
  const shortenedUrlWithHost = `${host}/${path}`;

  return {
    shortenedUrlWithOrigin,
    shortenedUrlWithHost,
  };
}