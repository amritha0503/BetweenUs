String getEmpathyBadge(double avgScore) {
  if (avgScore >= 0.8) return "🥇 Empathy Hero";
  if (avgScore >= 0.6) return "🥈 Listener Pro";
  if (avgScore >= 0.4) return "🥉 Support Buddy";
  return "🔰 Empathy Explorer";
}
