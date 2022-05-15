module deta

import net.http

//* SEE: https://docs.deta.sh/docs/base/http
[noinit]
pub struct Base {
	deta &Deta [required]
pub:
	name string [required]
}

[inline]
fn (base Base) get_url() string {
	return 'https://database.deta.sh/v1/$base.deta.project_id/$base.name'
}
