import { apiClient } from "./apiClient";

type RedirectResponse = {
  targetUrl?: string;
  errorStatusCode?: number;
};

export async function getRedirectLink(
  shortPath: string,
  ipAddress: string | null
): Promise<RedirectResponse> {
  try {
    const response = await apiClient(
      `/api/v1/shortened_paths/${shortPath}/redirect`,
      {
        params: {
          ip_address: ipAddress || undefined,
        },
      }
    );

    return response;
  } catch (error) {
    return { errorStatusCode: error.status };
  }
}
