resource "aws_cloudwatch_dashboard" "example_dashboard" {
  dashboard_name = "K8s_dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${var.master_id}"
          ],
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${var.workers_id[0]}"
          ],
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${var.workers_id[1]}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU Utilization"
      }
    }
  ]
}
EOF
}
