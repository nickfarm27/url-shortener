import {
  Links,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
  useLoaderData,
  useRouteError,
} from "@remix-run/react";
import type { LinksFunction } from "@remix-run/node";
import styles from "./tailwind.css?url";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";

export const links: LinksFunction = () => [
  { rel: "preconnect", href: "https://fonts.googleapis.com" },
  {
    rel: "preconnect",
    href: "https://fonts.gstatic.com",
    crossOrigin: "anonymous",
  },
  {
    rel: "stylesheet",
    href: "https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap",
  },
  { rel: "stylesheet", href: styles },
];

// this makes window.ENV type safe
declare global {
  interface Window {
    ENV: {
      API_SERVER_URL: string;
    };
  }
}

// setting browser env based on this https://remix.run/docs/en/main/guides/envvars#browser-environment-variables
export async function loader() {
  return {
    ENV: {
      API_SERVER_URL: process.env.API_SERVER_URL || "",
    },
  };
}

function Document({
  children,
  env = {},
}: {
  children: React.ReactNode;
  env?: Record<string, string>;
}) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <Links />
      </head>
      <body>
        {children}
        <script
          dangerouslySetInnerHTML={{
            __html: `window.ENV = ${JSON.stringify(env)}`,
          }}
        />
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

const queryClient = new QueryClient();

export default function App() {
  const { ENV } = useLoaderData<typeof loader>();

  return (
    <Document env={ENV}>
      <QueryClientProvider client={queryClient}>
        <Outlet />
        <ReactQueryDevtools initialIsOpen={false} />
      </QueryClientProvider>
    </Document>
  );
}

export function ErrorBoundary() {
  const error = useRouteError();

  const header = error.status === 404 ? "Error 404: Page not found" : "Something went wrong";
  const message = error.status === 404 ? "This page does not exist" : "Something went wrong with the request. Please try again.";

  return (
    <Document>
      <div className="flex h-[100dvh] items-center justify-center">
        <div className="flex flex-col items-center gap-4">
          <h1 className="text-3xl font-bold">{header}</h1>
          <p className="text-lg">
            {message}
          </p>
        </div>
      </div>
    </Document>
  );
}
