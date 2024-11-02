import { ShortenedUrlDetails } from "~/components/analytics/shortened-url-details";
import { CountriesChart } from "~/components/analytics/countries-chart";
import { ClickLog } from "~/components/analytics/click-log";

export default function ShortLinkAnalytics() {
  return (
    <div className="w-full p-4 bg-slate-100 flex justify-center min-h-[100dvh]">
      <div className="space-y-4 w-full max-w-2xl">
        <ShortenedUrlDetails />
        <CountriesChart />
        <ClickLog />
      </div>
    </div>
  );
}
