module deta

import os

[heap; noinit]
pub struct Deta {
	api_key string
pub:
	project_id string
}

fn verify_name(name string) ! {
	if name.trim_space() == '' {
		return error('Deta: name cannot be empty')
	}
}

// base returns a new Base instance.
pub fn (deta &Deta) base(name string) !&Base {
	verify_name(name) !

	return &Base{
		name: name
		deta: deta
	}
}

pub fn (deta &Deta) drive(name string) !&Drive {
	verify_name(name) !

	return &Drive{
		name: name
		deta: deta
	}
}

[params]
struct Deta_cfg {
mut:
	key string
	id  string
}

pub fn deta(mut cfg Deta_cfg) !&Deta {
	key, id := get_project_key_id(mut cfg) !
	return &Deta{
		api_key: key
		project_id: id
	}
}

[inline]
pub fn is_micro() bool {
	return os.getenv('DETA_RUNTIME') == 'true'
}

fn get_project_key_id(mut cfg Deta_cfg) !(string, string) {
	if cfg.key.trim_space() == '' {
		cfg.key = os.getenv('DETA_API_KEY')
		if cfg.key.trim_space() == '' {
			return error('Deta: no api key set')
		}
	}

	if cfg.id.trim_space() == '' {
		mut id := cfg.key.split('_').first()
		if id.trim_space() == '' {
			id = os.getenv_opt('DETA_PROJECT_ID') or {
				return error('Deta: no project id set')
			}
		}
		cfg.id = id
	}

	if cfg.id.trim_space() == '' {
		return error('Deta: No project id given')
	} else if cfg.id == cfg.key {
		return error('Deta: Bad project key provided')
	}

	return cfg.key, cfg.id
}
