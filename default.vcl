
vcl 4.0;

import std;
import cookie;
import blob;
import header;
import flagship;

backend default {
  .host = "example:3000";
}

sub vcl_init {
  flagship.init(envID=std.getenv("FS_ENV_ID"), apiKey=std.getenv("FS_API_KEY"), pollingInterval=10, logLevel="debug");
}

sub vcl_recv {
	unset req.http.x-cache;

  # Get from cookie of set the visitor ID
  if (req.http.cookie ~ "FS-VISITOR-ID=") {
    set req.http.X-VISITOR-ID = blob.transcode(encoded=regsub(req.http.cookie, ".*FS-VISITOR-ID=([^;]+);?.*", "\1"), decoding=URL);
  } else {
    set req.http.X-VISITOR-ID = "" + std.random(0, 100000);
  }

  # initialize the visitor context
  if (req.http.User-Agent ~ "Chrome") {
      set req.http.X-VISITOR-CONTEXT  = "device:chrome";
  }

  return(hash);
}

sub vcl_hash {
  hash_data(req.url);

  # this is where we should call flagship code to compute flag values
  set req.http.X-FS-FLAGVALUES = flagship.compute_flags(req.http.X-VISITOR-ID, req.http.X-VISITOR-CONTEXT);

  # the builtin.vcl will take care of also varying cache on those flag values
  hash_data(req.http.X-FS-FLAGVALUES);
}

# Log cache miss, hit, pass, pipe & synth in header
sub vcl_hit {
	set req.http.x-cache = "hit";
}

sub vcl_miss {
	set req.http.x-cache = "miss";
}

sub vcl_pass {
	set req.http.x-cache = "pass";
}

sub vcl_pipe {
	set req.http.x-cache = "pipe uncacheable";
}

sub vcl_synth {
	set req.http.x-cache = "synth synth";
}

# This function is used when a request is sent by our backend
sub vcl_backend_response {
  # If we find our layout cookie we copy it to a header and then we remove it so we can cache the page
  # Later after we deliver the page from cache we set the cookie from the header and then remove that header
  if ( beresp.http.Set-Cookie ) {
    set beresp.http.fs-cookie = beresp.http.Set-Cookie;
    unset beresp.http.Set-Cookie;
  }
}

sub vcl_deliver {

  if(resp.http.fs-cookie){
    set resp.http.Set-Cookie = resp.http.fs-cookie;
    unset resp.http.fs-cookie;
  }

  # Add flagship values to cookie if set
  if (req.http.X-VISITOR-ID) {
    header.append(resp.http.Set-Cookie,"FS-VISITOR-ID=" + blob.transcode(encoded=req.http.X-VISITOR-ID, encoding=URL) + "; Domain=localhost");
  }

  if (obj.uncacheable) {
		set resp.http.x-cache = req.http.x-cache + " uncacheable" ;
	} else {
		set resp.http.x-cache = req.http.x-cache + " cached" ;
	}
}