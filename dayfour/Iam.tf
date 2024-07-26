# Get IAM user Mahmoud
resource "aws_iam_user" "Mahmoud" {
  name = "Mahmoud" 
}

# Get IAM user Ahmed
resource "aws_iam_user" "Ahmed" {
  name = "Ahmed" 
}

# Get IAM user
resource "aws_iam_user" "Mostafa" {
  name = "Mostafa" 
}

# Create policy document

 # Ahmed With EC2 Administrator Policy "AWS Managed policy"
resource "aws_iam_user_policy_attachment" "ahmed_admin_policy" {
  user       = aws_iam_user.Ahmed.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

 # Mahmoud s3 get policy
resource "aws_iam_policy" "Mahmoud_s3_get_policy" {
  name   = "Mahmoud_s3_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
        "s3:PutObject",      
        "s3:GetObject"
        ],
        Resource = "arn:aws:s3:::s3-1/*",
        Condition = {                            # get objects restricted with specific source IP
          IpAddress = {
            "aws:SourceIp" = "49.205.35.242/32"   
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "Mahmoud_policy_attachment" {
  user       = aws_iam_user.Mahmoud.name
  policy_arn = aws_iam_policy.Mahmoud_s3_get_policy.arn
}

# Create IAM Role for Mostafa
resource "aws_iam_role" "iam_role_get_s3_Mostafa" {
  name                 = "s3_get_access_role"
  assume_role_policy   = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "${aws_iam_user.Mostafa.arn}"
            }
        }
    ]
})
}

# Creaet policy s3
resource "aws_iam_policy" "s3_get_policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::s3-1/Mostsfa"
      },
    ]
  })
}

# attche s3 get policy to the role
resource "aws_iam_role_policy_attachment" "Mostafa_role_attachment" {
  role       = aws_iam_role.iam_role_get_s3_Mostafa.name
  policy_arn = aws_iam_policy.s3_get_policy.arn
}