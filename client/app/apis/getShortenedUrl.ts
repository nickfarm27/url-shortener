import { apiClient } from "~/apiClient";
import { ShortenedUrl } from "~/types/shortenedUrl";

export async function getShortenedUrl(
  shortenedUrlId: string
): Promise<ShortenedUrl | undefined> {
  try {
    return await apiClient(`/api/v1/shortened_urls/${shortenedUrlId}`);
  } catch (error) {
    if (error.status === 404) {
      return undefined;
    } else {
      throw error;
    }
  }
}
