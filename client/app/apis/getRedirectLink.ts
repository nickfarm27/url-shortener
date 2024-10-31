import { apiClient } from "../apiClient";

type RedirectResponse = {
  targetUrl: string;
  errorStatusCode?: number;
};

export async function getRedirectLink(
  shortPath: string,
  ipAddress?: string
): Promise<RedirectResponse> {
  try {
    return await apiClient(
      `/api/v1/shortened_paths/${shortPath}/redirect`,
      {
        params: {
          ip_address: ipAddress,
        },
      }
    );
  } catch (error) {
    return { errorStatusCode: error.status, targetUrl: "" };
  }
}
