import type { MetaFunction } from "@remix-run/node";
import { Card, CardContent, CardHeader, CardTitle } from "~/components/ui/card";

export const meta: MetaFunction = () => {
  return [{ title: "URL Shortener" }];
};

export default function Index() {
  return (
    <div className="flex h-[100dvh] items-center justify-center">
      <Card className="min-w-[450px]">
        <CardHeader>
          <CardTitle className="text-center text-2xl">URL Shortener</CardTitle>
        </CardHeader>
        <CardContent>Content</CardContent>
      </Card>
    </div>
  );
}
