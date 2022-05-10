module deta

import os
import json
import net.http

type Strings = []string | string

[params]
struct Mail {
	to      Strings [required]
	subject string
	message string
	charset string = 'utf-8'
}

fn (m Mail) normalize() Mail {
	if m.to is string {
		return Mail{
			to: [m.to]
			subject: m.subject
			message: m.message
			charset: m.charset
		}
	} else {
		return m
	}
}

// send_email is taken from: https://github.com/deta/deta-python/blob/master/deta/__init__.py#L62
fn (deta &Deta) send_email(mail Mail) ?http.Response {
	pid := os.getenv('AWS_LAMBDA_FUNCTION_NAME')
	url := os.getenv('DETA_MAILER_URL')
	endpoint := '$url/mail/$pid'

	mut fetch := http.FetchConfig{
		url: endpoint
		data: json.encode(mail.normalize())
	}

	fetch.header.set(http.CommonHeader.content_type, 'application/json')
	fetch.header.set_custom('X-Api-Key', deta.api_key) ?

	return http.fetch(fetch)
}
