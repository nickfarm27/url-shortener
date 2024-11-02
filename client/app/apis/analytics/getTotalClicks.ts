import { apiClient } from "~/apiClient";

type TotalClicksResponse = {
  totalClicks: number;
};

export async function getTotalClicks(
  shortenedUrlId: string
): Promise<TotalClicksResponse> {
  try {
    return await apiClient(
      `/api/v1/analytics/shortened_urls/${shortenedUrlId}/total_clicks`
    );
  } catch (error) {
    if (error.status === 404) {
      return { totalClicks: 0 };
    } else {
      throw error;
    }
  }
}
