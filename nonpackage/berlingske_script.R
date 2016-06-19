fiftysix::workhorse()

b <- berlingskebarometer()

b$letter <- factor(b$letter, levels = unique(b$letter))
partycolors$partyletter <- factor(partycolors$partyletter, levels = levels(b$letter))
partycolors$partycolor <- factor(partycolors$partycolor, levels = partycolors$partycolor[as.numeric(partycolors$partyletter)])

require(scales)

ggplot(b, aes(datetime, percent/100, group = letter, color = letter)) +
  annotate("rect",
           xmin = min((b$datetime)),
           xmax = max((b$datetime)),
           ymin = 0, ymax = 10/100,  alpha=0.2, fill="lightgray") +
  annotate("rect",
           xmin = min(b$datetime),
           xmax = max(b$datetime),
           ymin = 16/100,
           ymax = max((b$percent)/100+.5/100),  alpha=0.2, fill="lightgray") +
  geom_line(, show.legend = F) +
  scale_color_manual(values = partycolors) +
  scale_y_continuous(labels=percent) +
  labs(y = "",
       x = "",
       title = 'Dansk politik er delt op i to lag: "status quo"- og reform-partier',
       subtitle = 'Der er grundlæggende to niveauer i dansk politik:
       1) De partier, der ønsker at bevare "status quo", nemlig de tre store partier: A, V og O
       2) De partier, der ønsker reformer, nemlig de resterende syv små partier: Ø, Å, I, B, F, C og K',
       caption = "Kilde: Berlingske Barometer 2016") +
  theme_minimal() +
  theme(panel.grid = element_blank())

ggsave(filename = "twotier.png")
