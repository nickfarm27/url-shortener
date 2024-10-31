import type { MetaFunction } from "@remix-run/node";
import { Button } from "~/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "~/components/ui/card";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "~/components/ui/form";
import { Input } from "~/components/ui/input";
import { useCreateShortenedUrl } from "~/hooks/useCreateShortenedUrl";
import { useState } from "react";
import { CreatedLinkModal } from "~/components/created-link-modal";
import { AllLinksSheet } from "~/components/all-links-sheet";
import { useQueryClient } from "@tanstack/react-query";

const formSchema = z.object({
  targetUrl: z
    .string({
      required_error: "Target URL is required",
    })
    .url({
      message: "Target URL must be a valid URL",
    }),
  title: z.string().optional(),
});

export const meta: MetaFunction = () => {
  return [{ title: "URL Shortener" }];
};

export default function Index() {
  const { create, isPending } = useCreateShortenedUrl();
  const [errorMessage, setErrorMessage] = useState("");
  const [newShortenedUrl, setNewShortenedUrl] = useState<{
    path: string;
    targetUrl: string;
    title?: string;
  }>();
  const [openCreatedLinkModal, setOpenCreatedLinkModal] = useState(false);

  const queryClient = useQueryClient();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      targetUrl: "",
      title: "",
    },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    create(values, {
      onSuccess(data) {
        const errorStatusCode = data.errorStatusCode;
        if (errorStatusCode) {
          setErrorMessage(
            "Something went wrong when creating the URL. Please try again."
          );
          return;
        }
        setNewShortenedUrl(data);
        setOpenCreatedLinkModal(true);
        setErrorMessage("");
        queryClient.invalidateQueries({ queryKey: ["shortenedUrls"] });
        form.reset();
      },
      onError(error) {
        setErrorMessage(error.message);
      },
    });
  }

  return (
    <div className="flex h-[100dvh] items-center justify-center bg-slate-100">
      <Card className="w-full max-w-md m-4">
        <CardHeader>
          <CardTitle className="text-center text-2xl">
            Shorten your URL!
          </CardTitle>
        </CardHeader>
        <CardContent>
          {errorMessage && (
            <p className="text-destructive mb-2 text-sm">{errorMessage}</p>
          )}
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
              <FormField
                control={form.control}
                name="targetUrl"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Target URL</FormLabel>
                    <FormControl>
                      <Input
                        placeholder="https://myreallylongurl.com"
                        {...field}
                      />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="title"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Title (optional)</FormLabel>
                    <FormControl>
                      <Input placeholder="My Awesome URL" {...field} />
                    </FormControl>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <Button type="submit" className="w-full" disabled={isPending}>
                {isPending ? "Shortening..." : "Shorten URL"}
              </Button>
            </form>
          </Form>
        </CardContent>
      </Card>
      <CreatedLinkModal shortenedUrl={newShortenedUrl} open={openCreatedLinkModal} onOpenChange={setOpenCreatedLinkModal} />
      <AllLinksSheet />
    </div>
  );
}
