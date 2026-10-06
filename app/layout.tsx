import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "WhoSabi | Know before you rent",
  description: "Transparent rental costs, reviews, rent receipts and maintenance for Nigerian homes.",
  other: {
    "codex-preview": "development",
  },
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
