#include "config.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <libflagship.h>

#include "cache/cache.h"

#include "vtim.h"
#include "vcc_flagship_if.h"

VCL_VOID
vmod_init(VRT_CTX, VCL_STRING envId, VCL_STRING apiKey, VCL_INT pollingInterval, VCL_STRING logLevel)
{
	initFlagship(strdup(envId), strdup(apiKey), pollingInterval, strdup(logLevel));
}

VCL_STRING
vmod_compute_flags(VRT_CTX, VCL_STRING visitorId, VCL_STRING context)
{	
	char *buf = getAllFlags(strdup(visitorId), strdup(context));
	return buf;
}
