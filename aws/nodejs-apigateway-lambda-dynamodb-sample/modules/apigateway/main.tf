resource aws_api_gateway_rest_api rest_api {
  name = var.rest_api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource aws_api_gateway_resource resource {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource aws_api_gateway_method method {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.resource.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = false
}

resource aws_api_gateway_integration integration {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource aws_api_gateway_deployment deployment {
  rest_api_id       = aws_api_gateway_rest_api.rest_api.id
  stage_name        = var.stage_name
  stage_description = "stage deployed at ${timestamp()}"

  depends_on = [
    aws_api_gateway_integration.integration
  ]

  lifecycle {
    create_before_destroy = true
  }
}