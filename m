Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Aug 2007 06:44:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7HDiJbm021242
	for <xfs@oss.sgi.com>; Fri, 17 Aug 2007 06:44:20 -0700
Message-ID: <46C5A63E.5070906@sandeen.net>
Date: Fri, 17 Aug 2007 08:44:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs/xfsdump: what flavor of GPL...?
References: <46C3CC46.8030005@redhat.com>
In-Reply-To: <46C3CC46.8030005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Fedora is making a push to clarify licensing on all packages -
> 
> GPL+, GPLv2, GPLv2+, GPLv3, GPLv3+, LGPLv2, LGPLv2+, LGPLv3, LGPLv3+
> 
> are the acceptable license tags for rpm packaging at this point. ("+"
> means "or later").

Of course, the tag I put on the package is in no way binding for sgi -
it's just supposed to reflect the license inside.  But it does point out
a bit of confusion now that gplv3 is on the scene.

I'll follow fedora guidelines & put GPL+ and LGPLv2+ in the field for
now; when I get clarification from SGI I'll fix up if needed.

Thanks,
-Eric

> Looking, for example, at mkfs/xfs_mkfs.c:
> 
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License as
>  * published by the Free Software Foundation.
> 
> it makes no mention of GPL _version_.
> 
> With all the ruckus lately over GPLv3, could sgi please clarify?  Since
> the included COPYING file says LGPL 2.1 and GPL2, I assume that LGPLv2
> and GPLv2 are appropriate for the package.
> 
> It'd be tedious, but you may wish to specify exactly which version of
> the license in the actual source files...
> 
> Thanks,
> 
> -Eric
> 
> 
