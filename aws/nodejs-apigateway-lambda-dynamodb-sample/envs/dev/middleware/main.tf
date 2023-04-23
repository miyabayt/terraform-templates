# dynamodb
resource aws_dynamodb_table dynamodb_table {
    for_each = { for table in local.dynamodb_tables : table.table_name => table }

    name         = each.value.table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = each.value.hash_key

    attribute {
        name = each.value.hash_key
        type = each.value.hash_key_type
    }
}
