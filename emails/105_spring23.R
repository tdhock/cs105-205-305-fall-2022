library(data.table)
name.dt <- nc::capture_all_str(
  "105_spring23.txt",
  student.last=list(letter="[A-Z]", "[^ ,;]+"),
  ",",
  student.first="[^;]+")[order(student.last)]
set.seed(13)
graders <- nc::capture_first_df(
  data.table::fread("spring23_graders.csv"),
  name=list(grader="[^ ]+", " <"))[sample(1:.N)]
graders[, cum.hours := cumsum(hours)]
letter.dt <- name.dt[, .(students=.N), by=letter]
graders[, last.row := cum.hours*nrow(letter.dt)/max(cum.hours)]
graders[, first.row := c(0, last.row[-.N])]
letter.dt[, row := .I]
letter.graders <- letter.dt[graders, .(
  letter, grader, hours, students
), on=.(row>first.row, row<=last.row)]
graders.wide <- letter.graders[, .(
  students=sum(students),
  first.letter=min(letter),
  last.letter=max(letter)
), by=.(grader, hours)]
graders.tall <- melt(
  graders.wide, measure=c("students","hours")
)[, prop := value/sum(value), by=variable][]
(graders.compare <- dcast(graders.tall, grader ~ variable, value.var=c("value","prop")))
(worst <- sum(graders.compare[, max(abs(prop_hours-prop_students))]))

