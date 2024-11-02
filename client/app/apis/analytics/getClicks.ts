import { apiClient } from "~/apiClient";

type Click = {
  id: number;
  createdAt: string;
  country: string | null;
};

type ClicksResponse = {
  clicks: Click[];
  meta: {
    count: number;
    page: number;
    last: number;
    prev: number | null;
    next: number | null;
  };
};

export async function getClicks(
  shortenedUrlId: string,
  page: number
): Promise<ClicksResponse> {
  try {
    return await apiClient(
      `/api/v1/analytics/shortened_urls/${shortenedUrlId}/clicks`,
      {
        params: {
          page,
        },
      }
    );
  } catch (error) {
    if (error.status === 404) {
      return {
        clicks: [],
        meta: { count: 0, page: 1, last: 0, prev: null, next: null },
      };
    } else {
      throw error;
    }
  }
}
