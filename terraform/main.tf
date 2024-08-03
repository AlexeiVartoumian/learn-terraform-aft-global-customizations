resource "aws_s3_account_public_access_block" "block_all_public"{
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

resource "aws_sns_topic" "aft_notifications" {
    name = "aft-global-notifications"

    tags = {
        Name="AFT Global notifications"
        Environment = "Production"
        Managed_By = "Terraform"
    }
}

resource "aws_sns_topic_policy" "default" {
    arn = aws_sns_topic.aft_notifications.arn

    policy = jsonencode({
        Version = "2021-10-17"
        Id = "aft-sns-topic-policy"
        Statement = [
            {
                Sid = "AllowPublishFromAFT"
                Effect = "Allow"
                Principal = {
                    Service = "events.amazonaws.com"
                }
                Action = "SNS:Publish"
                Resource = aws_sns_topic.aft_notifications.arn
            }
        ]
    })
}