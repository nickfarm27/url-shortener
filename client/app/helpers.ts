// reference: https://dev.to/remix-run-br/type-safe-environment-variables-on-both-client-and-server-with-remix-54l5
type publicEnvKeys = "API_SERVER_URL";

export function getPublicEnv(key: publicEnvKeys): string | undefined {
  return typeof window === "undefined"
    ? process.env[key]
    : (window.ENV as { [key: string]: string })[key];
}
