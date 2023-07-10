variable "server_port" {
	description = "The port the server will use for HTTP requests"
	type 		= number
	default		= 8080

}

output "public_ip" {
	value 	= aws_instance.TerraExample.public_ip
	description = "The publi IP address of the web server"
}