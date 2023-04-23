resource aws_waf_size_constraint_set waf_size_constraint_set {
  name = var.waf_size_constraint_set_name

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "4096"

    field_to_match {
      type = "BODY"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "4093"

    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "1024"

    field_to_match {
      type = "QUERY_STRING"
    }
  }

  size_constraints {
    text_transformation = "NONE"
    comparison_operator = "GT"
    size                = "512"

    field_to_match {
      type = "URI"
    }
  }
}

resource aws_waf_rule waf_rule_size_constraint {
  name        = var.waf_rule_size_constraint_name
  metric_name = var.waf_rule_size_constraint_metric_name

  predicates {
    data_id = aws_waf_size_constraint_set.waf_size_constraint_set.id
    negated = false
    type    = "SizeConstraint"
  }
}
