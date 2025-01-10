data "aws_caller_identity" "current" {}

resource "aws_athena_workgroup" "vpc_flow_logs" {
  name = var.workgroup_name

  configuration {
    result_configuration {
      output_location = "s3://${var.s3_bucket_name}/athena-results/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = var.force_destroy
}

resource "aws_glue_catalog_database" "vpc_flow_logs" {
  name        = local.name
  description = "VPC Flow Logs"
}

resource "aws_glue_catalog_table" "vpc_flow_logs" {
  name          = "vpc_flow_logs"
  database_name = aws_glue_catalog_database.vpc_flow_logs.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "storage.location.template" = "s3://${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${local.region}/$${date}"
  }

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${local.region}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = " "
      }
    }

    dynamic "columns" {
      for_each = local.ordered_table_columns
      content {
        name = columns.value.key
        type = columns.value.value
      }
    }
  }

  dynamic "partition_keys" {
    for_each = local.ordered_partition_keys
    content {
      name = partition_keys.value.key
      type = partition_keys.value.value
    }
  }
}

resource "aws_athena_named_query" "VpcFlowLogsTotalBytesTransferred" {
  name        = "VpcFlowLogsTotalBytesTransferred"
  description = "Top 50 pairs of source and destination IP addresses with the most bytes transferred."
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
  SELECT SUM(bytes) as totalbytes, srcaddr, dstaddr from vpc_flow_logs
  GROUP BY srcaddr, dstaddr
  ORDER BY totalbytes
  LIMIT 50
EOT
}

resource "aws_athena_named_query" "VpcFlowLogsSshRdpTraffic" {
  name        = "VpcFlowLogsSshRdpTraffic"
  description = "Monitor SSH and RDP traffic"
  workgroup   = aws_athena_workgroup.vpc_flow_logs.id
  database    = aws_glue_catalog_database.vpc_flow_logs.id
  query       = <<EOT
SELECT *
FROM vpc_flow_logs
WHERE srcport in (22,3389) OR dstport IN (22, 3389)
ORDER BY "start" ASC
limit 50
EOT
}