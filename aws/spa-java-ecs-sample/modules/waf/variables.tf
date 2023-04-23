# waf
variable waf_ipset_allowed_name {}

variable waf_ipset_descriptors {
  type = list
}

variable waf_size_constraint_set_name {}
variable waf_sql_injection_match_set_name {}
variable waf_xss_match_set_name {}

variable waf_rule_size_constraint_name {}
variable waf_rule_size_constraint_metric_name {}
variable waf_rule_sqli_name {}
variable waf_rule_sqli_metric_name {}
variable waf_rule_xss_name {}
variable waf_rule_xss_metric_name {}
variable waf_rule_ipset_allowed_name {}
variable waf_rule_ipset_allowed_metric_name {}

variable waf_web_acl_name {}
variable waf_web_acl_metric_name {}
