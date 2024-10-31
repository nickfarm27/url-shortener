import { apiClient } from "../apiClient";

type CreateShortenedUrlResponse = {
  id: number;
  title: string;
  path: string;
  targetUrl: string;
  createdAt: string;
  errorStatusCode?: number;
};

type CreateShortenedUrlBody = {
  targetUrl: string;
  title?: string;
};

const nullShortenedUrlResponse = {
  id: 0,
  title: "",
  path: "",
  targetUrl: "",
  createdAt: "",
};

export async function createShortenedUrl({
  targetUrl,
  title,
}: CreateShortenedUrlBody): Promise<CreateShortenedUrlResponse> {
  try {
    return await apiClient(`/api/v1/shortened_urls`, {
      method: "POST",
      body: {
        target_url: targetUrl,
        title,
      },
    });
  } catch (error) {
    if (error.status) {
      return { errorStatusCode: error.status, ...nullShortenedUrlResponse };
    } else {
      throw error;
    }
  }
}
