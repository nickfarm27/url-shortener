import { apiClient } from "~/apiClient";
import { ShortenedUrl } from "~/types/shortenedUrl";

type ShortenedUrlsResponse = {
  shortenedUrls: ShortenedUrl[];
  meta: {
    count: number;
    page: number;
    last: number;
    prev: number | null;
    next: number | null;
  };
};

export async function getShortenedUrls({
  pageParam,
}: {
  pageParam: number;
}): Promise<ShortenedUrlsResponse> {
  return await apiClient(`/api/v1/shortened_urls`, {
    params: {
      page: pageParam,
    },
  });
}
