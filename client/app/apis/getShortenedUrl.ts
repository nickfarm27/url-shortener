import { apiClient } from "~/apiClient";
import { ShortenedUrl } from "~/types/shortenedUrl";

export async function getShortenedUrl(
  shortenedUrlId: string
): Promise<ShortenedUrl> {
  try {
    return await apiClient(`/api/v1/shortened_urls/${shortenedUrlId}`);
  } catch (error) {
    if (error.status === 404) {
      return {
        id: 0,
        title: "",
        path: "",
        targetUrl: "",
        createdAt: "",
      };
    } else {
      throw error;
    }
  }
}
