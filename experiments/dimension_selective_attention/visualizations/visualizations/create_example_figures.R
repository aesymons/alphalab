library(ggplot2)
library(grid)

# This script creates a set of example figures
# You will want to change these figures to match your examples
# You can also modify this script to create examples where pitch changes at one rhythm and duration at another
# Enjoy!

# Duration 3, Pitch 0
x1 = seq(0.5,6,0.5)
x2 = x1 + rep( c(rep(0.2,3),rep(0.35,3)), length(x1)/6)
y1 = rep(0.05,12) # No pitch change 
y2 = y1 + 0.015

dur=data.frame(x1,x2,y1,y2)

# Duration 3, Pitch 0 (with repetition)
x1 = seq(0.5,6,0.5)
x2 = x1 + c( rep(0.2,3), rep(0.35,6), rep (0.2,3))
y1 = rep(0.05,12) # No pitch change 
y2 = y1 + 0.015

dur_rep=data.frame(x1,x2,y1,y2)

# Pitch 2, Duration 0 
x1 = seq(0.5,6,0.5)
x2 = x1 + rep(0.2,length(x1)) # No duration change
y1 = rep( c(rep(0.05,2),rep(0.1,2)), length(x1)/4)
y2 = y1 + 0.015

pitch=data.frame(x1,x2,y1,y2)

# Pitch 2, Duration 0 (with repetition)
x1 = seq(0.5,6,0.5)
x2 = x1 + rep(0.2,length(x1)) # No duration change
y1 = c( rep(0.05,2), rep(0.1,2), rep(0.05,2),rep(0.1,4), rep(0.05,2))
y2 = y1 + 0.015

pitch_rep=data.frame(x1,x2,y1,y2)

# Duration Plot
p1 <- ggplot() + 
  scale_x_continuous(name="Time", limits = c(0,6.65),breaks = NULL) + 
  scale_y_continuous(name="Pitch",limits = c(0,0.5), breaks = NULL) +
  geom_rect(data=dur, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2),fill='navyblue')+ 
  theme_classic() + 
  theme(legend.title = element_text(angle = 270),
        legend.title.align = 0.5,
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.title = element_text(size = 8),
        axis.title.y = element_text(hjust=0.17, vjust = -5))

p1 <- p1 + geom_segment(aes(x = 0, y = 0, xend = 6.65, yend = 0),
                        arrow = arrow(length = unit(0.24, "cm")))+
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 0.2),
               arrow = arrow(length = unit(0.24, "cm")))+
  annotate("text", x = 3.15, y = 0.22, label = "Duration changes every 3 sounds", size = 4)

plot(p1)

png(filename = "pitch0_dur3_figure.png", width = 1600, height = 800, units = "px", res = 300)
plot(p1)
dev.off()

# Pitch Plot
p2 <- ggplot() + 
  scale_x_continuous(name="Time", limits = c(0,6.65),breaks = NULL) + 
  scale_y_continuous(name="Pitch",limits = c(0,0.5), breaks = NULL) +
  geom_rect(data=pitch, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2),fill='navyblue')+ 
  theme_classic() + 
  theme(legend.title = element_text(angle = 270),
        legend.title.align = 0.5,
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.title = element_text(size = 8),
        axis.title.y = element_text(hjust=0.17, vjust = -5))

p2 <- p2 + geom_segment(aes(x = 0, y = 0, xend = 6.65, yend = 0),
                        arrow = arrow(length = unit(0.24, "cm")))+
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 0.2),
               arrow = arrow(length = unit(0.24, "cm")))+
  annotate("text", x = 3.15, y = 0.22, label = "Pitch changes every 2 sounds", size = 4)

plot(p2)

png(filename = "pitch2_dur0_figure.png", width = 1600, height = 800, units = "px", res = 300)
plot(p2)
dev.off()

# Duration Plot (Repetition)
p3 <- ggplot() + 
  scale_x_continuous(name="Time", limits = c(0,6.65),breaks = NULL) + 
  scale_y_continuous(name="Pitch",limits = c(0,0.5), breaks = NULL) +
  geom_rect(data=dur_rep, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2),fill='navyblue')+ 
  theme_classic() + 
  theme(legend.title = element_text(angle = 270),
        legend.title.align = 0.5,
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.title = element_text(size = 8),
        axis.title.y = element_text(hjust=0.17, vjust = -5))

p3 <- p3 + geom_segment(aes(x = 0, y = 0, xend = 6.65, yend = 0),
                        arrow = arrow(length = unit(0.24, "cm")))+
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 0.2),
               arrow = arrow(length = unit(0.24, "cm")))+
  annotate("text", x = 3.15, y = 0.22, label = "Duration changes every 3 sounds", size = 4)+
  annotate("rect", xmin = 1.9, xmax = 4.95, ymin = 0.025, ymax = 0.1,
           alpha = .3)+
  annotate("text", x = 3.4, y = 0.12, label = "Repetition!", size = 3)

png(filename = "pitch0_dur3_repetition_figure.png", width = 1600, height = 800, units = "px", res = 300)
plot(p3)
dev.off()


# Pitch Plot (Repetition)
p4 <- ggplot() + 
  scale_x_continuous(name="Time", limits = c(0,6.65),breaks = NULL) + 
  scale_y_continuous(name="Pitch",limits = c(0,0.5), breaks = NULL) +
  geom_rect(data=pitch_rep, mapping=aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2),fill='navyblue')+ 
  theme_classic() + 
  theme(legend.title = element_text(angle = 270),
        legend.title.align = 0.5,
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.title = element_text(size = 8),
        axis.title.y = element_text(hjust=0.17, vjust = -5))

p4 <- p4 + geom_segment(aes(x = 0, y = 0, xend = 6.65, yend = 0),
                        arrow = arrow(length = unit(0.24, "cm")))+
  geom_segment(aes(x = 0, y = 0, xend = 0, yend = 0.2),
               arrow = arrow(length = unit(0.24, "cm")))+
  annotate("text", x = 3.15, y = 0.22, label = "Pitch changes every 2 sounds", size = 4)+
  annotate("rect", xmin = 3.4, xmax = 5.3, ymin = 0.08, ymax = 0.13,
           alpha = .3)+
  annotate("text", x = 4.3, y = 0.15, label = "Repetition!", size = 3)

plot(p4)

png(filename = "pitch2_dur0_repetition_figure.png", width = 1600, height = 800, units = "px", res = 300)
plot(p4)
dev.off()


