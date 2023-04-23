resource aws_waf_ipset waf_ipset_allowed {
  name = var.waf_ipset_allowed_name
  dynamic ip_set_descriptors {
    for_each = [for ipset in var.waf_ipset_descriptors : {
      type  = ipset.type
      value = ipset.value
    }]
    content {
      type  = ip_set_descriptors.value.type
      value = ip_set_descriptors.value.value
    }
  }
}

resource aws_waf_rule waf_rule_ipset_allowed {
  name        = var.waf_rule_ipset_allowed_name
  metric_name = var.waf_rule_ipset_allowed_metric_name

  predicates {
    data_id = aws_waf_ipset.waf_ipset_allowed.id
    negated = true
    type    = "IPMatch"
  }
}
