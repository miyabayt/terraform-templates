resource aws_waf_web_acl waf_web_acl {
  name        = var.waf_web_acl_name
  metric_name = var.waf_web_acl_metric_name

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.waf_rule_ipset_allowed.id
    type     = "REGULAR"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 2
    rule_id  = aws_waf_rule.waf_rule_size_constraint.id
    type     = "REGULAR"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 3
    rule_id  = aws_waf_rule.waf_rule_sqli.id
    type     = "REGULAR"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 4
    rule_id  = aws_waf_rule.waf_rule_xss.id
    type     = "REGULAR"
  }

  #   rules {
  #     action {
  #       type = "BLOCK"
  #     }

  #     priority = 6
  #     rule_id  = aws_waf_rule.detect_rfi_lfi_traversal.id
  #     type     = "REGULAR"
  #   }

  #   rules {
  #     action {
  #       type = "BLOCK"
  #     }

  #     priority = 9
  #     rule_id  = aws_waf_rule.detect_ssi.id
  #     type     = "REGULAR"
  #   }
}
