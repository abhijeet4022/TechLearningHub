resource "aws_route53_zone" "host" {
  name = "learntechnology.tech"

}

resource "aws_route53_record" "webserver-record" {
  zone_id = aws_route53_zone.host.zone_id
  name    = "www.${aws_route53_zone.host.name}"
  type    = "A"
  ttl     = "60"
  records = ["${aws_instance.web.public_ip}"]
}

output "ns-servers" {
  value = aws_route53_zone.host.name_servers
}

