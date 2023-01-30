emails <- nc::capture_all_str(
  "105.txt",
  user=list(
    "[a-z]+",
    number="[0-9]+"
  )
)[order(user)]
set.seed(1)
emails[, n.lines := sample(100:200, .N, replace=TRUE)]
user.letter <- emails[, .(
  letter=sample(LETTERS[1:6], n.lines, replace=TRUE)), by=user]
data.table::fwrite(user.letter[sample(.N), .(user)], "105_students_no_header.csv", col.names=FALSE)
data.table::fwrite(emails[, .(user, n.lines)], "105_answers.csv")
