# Terraform

## profileはcredentialsを参照する
誤爆を防ぐため、credentialsを参照する様に設定

credentialsの確認方法

```
$ cat ~/.aws/credentials

[default]
aws_access_key_id = [アクセスキー]
aws_secret_access_key = [シークレットキー]
```

```:terraform.tf
provider "aws" {
    profile = "default" # 各credentialを指定可能
    region = "ap-northeast-1"
}
```

## 環境によってvariable.tfの値は変更する
envの値はprd（本番環境）、dev（テスト環境とする）

```:variable.tf
variable "env" {
    type = string
    default = "dev" 
}
```

## SSHキーを作成する

```
$ ssh-keygen -t rsa -f [key名] -N ''
```

作成したkey名をec2.tfにセット

```
# $ ssh-keygen -t rsa -f example -N ''　で作成した場合

resource "aws_instance" "ec2" {
    ami = "ami-0a1c2ec61571737db"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.public_a.id
    root_block_device {
        volume_type = "gp2"
        volume_size = "30"
    }
    key_name = aws_key_pair.example.id # ←ここと
    tags = {
        Name = "${var.env}-${var.project}-ec2"
    }
}

output "ec2_public_ip" {
    value = aws_instance.ec2.public_ip
}

resource "aws_key_pair" "example" {  # ←ここと
  key_name   = "example"  # ←ここと
  public_key = file("./example.pub")  # ←ここ
}

```

## 実行コマンド

```
# 初期化
$ terraform init

# 確認
$ terraform plan

# OKであればapply
$ terraform apply

# 作成したものを削除
$ terraform destroy
```
