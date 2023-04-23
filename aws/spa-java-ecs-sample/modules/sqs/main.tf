resource aws_sqs_queue sqs_queue {
  for_each                    = toset(var.sqs_queues)
  name                        = each.value
  fifo_queue                  = true
  content_based_deduplication = true
}
