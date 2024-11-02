import { Card, CardContent, CardHeader, CardTitle } from "~/components/ui/card";
import {
  Bar,
  BarChart,
  XAxis,
  YAxis,
  CartesianGrid,
  LabelList,
} from "recharts";
import { useClicksByCountry } from "~/hooks/analytics/useClicksByCountry";
import { useParams } from "@remix-run/react";
import { Skeleton } from "../ui/skeleton";
import {
  ChartConfig,
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
} from "~/components/ui/chart";

const chartConfig = {
  country: {
    label: "Country",
    color: "hsl(var(--primary))",
  },
  count: {
    label: "Clicks",
    color: "hsl(var(--primary))",
  },
  label: {
    color: "hsl(var(--background))",
  },
} satisfies ChartConfig;

export function CountriesChart() {
  const params = useParams();
  const shortenedUrlId = params.shortenedUrlId as string;
  const { data, isLoading, error } = useClicksByCountry(shortenedUrlId);

  function ChartData() {
    if (isLoading) {
      return <Skeleton className="h-40 w-full" />;
    }

    if (error) {
      return (
        <p className="text-sm text-red-500">Error fetching clicks by country</p>
      );
    }

    if (!data || data.countries.length === 0) {
      return <p className="text-sm text-muted-foreground">No clicks found</p>;
    }

    const countriesData = data.countries.map((countryClicks) => ({
      ...countryClicks,
      country: countryClicks.country || "Unknown",
    }));

    return (
      <ChartContainer config={chartConfig}>
        <BarChart
          accessibilityLayer
          data={countriesData}
          layout="vertical"
          margin={{
            right: 16,
          }}
        >
          <CartesianGrid horizontal={false} />
          <YAxis
            dataKey="country"
            type="category"
            tickLine={false}
            tickMargin={10}
            axisLine={false}
            tickFormatter={(value) => value.slice(0, 3)}
            hide
          />
          <XAxis dataKey="count" type="number" hide />
          <ChartTooltip
            cursor={false}
            content={<ChartTooltipContent indicator="line" />}
          />
          <Bar
            dataKey="count"
            layout="vertical"
            fill="var(--color-count)"
            radius={4}
          >
            <LabelList
              dataKey="country"
              position="insideLeft"
              offset={8}
              className="fill-[--color-label]"
              fontSize={12}
            />
            <LabelList
              dataKey="count"
              position="right"
              offset={8}
              className="fill-foreground"
              fontSize={12}
            />
          </Bar>
        </BarChart>
      </ChartContainer>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Clicks by Country</CardTitle>
      </CardHeader>
      <CardContent>
        <ChartData />
      </CardContent>
    </Card>
  );
}
