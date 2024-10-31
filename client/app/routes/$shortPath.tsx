import { LoaderFunctionArgs } from "@remix-run/node";
import { redirect, useLoaderData } from "@remix-run/react";
import { getClientIPAddress } from "remix-utils/get-client-ip-address";
import { getRedirectLink } from "~/apis/getRedirectLink";

export const loader = async ({ request, params }: LoaderFunctionArgs) => {
  const shortPath = params.shortPath as string;
  const ipAddress = getClientIPAddress(request) || undefined;

  const response = await getRedirectLink(shortPath, ipAddress);

  if (response.errorStatusCode) {
    return {
      errorStatusCode: response.errorStatusCode,
    };
  }

  return redirect(response.targetUrl);
};

function getErrorMessage(statusCode: number | undefined) {
  switch (statusCode) {
    case 404:
      return "Error 404: This short URL does not exist.";
    default:
      return "Something went wrong with the request.";
  }
}

export default function ShortUrlNotFound() {
  const { errorStatusCode } = useLoaderData<typeof loader>();

  return (
    <div className="flex h-[100dvh] items-center justify-center bg-slate-100">
      <div className="flex flex-col items-center gap-4">
        <h1 className="text-3xl font-bold">Oops, something&apos;s wrong!</h1>
        <p className="text-lg">{getErrorMessage(errorStatusCode)}</p>
      </div>
    </div>
  );
}
