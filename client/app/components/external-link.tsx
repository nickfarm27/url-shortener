import { Link } from "@remix-run/react";

export function ExternalLink({
  to,
  className,
  children,
}: {
  to: string;
  className?: string;
  children: React.ReactNode;
}) {
  return (
    <Link
      to={to}
      rel="noopener noreferrer"
      target="_blank"
      className={`${className} break-all`}
    >
      {children}
    </Link>
  );
}
