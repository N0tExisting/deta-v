module deta

import net.http
import os

pub type File_ish = string | os.File

//* SEE: https://docs.deta.sh/docs/drive/http
[noinit]
pub struct Drive {
	deta &Deta [required]
pub:
	name string [required]
}

[inline]
fn (drive Drive) get_url() string {
	return "https://drive.deta.sh/v1/$drive.deta.project_id/$drive.name"
}
