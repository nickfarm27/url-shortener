import { apiClient } from "~/apiClient";

type ClicksByCountryResponse = {
  countries: {
    country: string;
    count: number;
  }[];
};

export async function getClicksByCountry(
  shortenedUrlId: string
): Promise<ClicksByCountryResponse> {
  try {
    return await apiClient(
      `/api/v1/analytics/shortened_urls/${shortenedUrlId}/clicks_by_countries`
    );
  } catch (error) {
    if (error.status === 404) {
      return { countries: [] };
    } else {
      throw error;
    }
  }
}