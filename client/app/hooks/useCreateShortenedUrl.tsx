import { useMutation } from "@tanstack/react-query";
import { createShortenedUrl } from "~/apis/createShortenedUrl";

export function useCreateShortenedUrl() {
  const { mutate: create, ...others } = useMutation({
    mutationFn: createShortenedUrl,
  });

  return { create, ...others };
}
