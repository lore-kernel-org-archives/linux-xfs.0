Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 223247F58
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 09:31:50 -0500 (CDT)
Message-ID: <5183CA60.2020308@sgi.com>
Date: Fri, 3 May 2013 09:32:00 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] xfstests: various fixes
References: <1367397123-2530-1-git-send-email-david@fromorbit.com>
	<20130501093139.GN10481@dastard>
In-Reply-To: <20130501093139.GN10481@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thanks Dave, this patchset has been committed.

--Rich

commit 87f5e8e2dbf02b3c4d804a797ed5a7a643f4b64e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 1 08:31:59 2013 +0000

     xfstests: fix last test runtime output

commit 97540f14f71e6785838532a982c443571380cfcc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 1 08:32:00 2013 +0000

     xfstests: 310 fails with existing directory error

commit 3ac75605de1fbbaae9505799b46c44fbe053f04e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 1 08:32:01 2013 +0000

     xfstests: filter EA paths used by dump

commit e6c6abd6dcacafa778d610451a023ec93c1b352e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 1 08:32:02 2013 +0000

     xfstests: fix incorrect redirect in generic/232

commit 627427bb1bb4007c661a178bbeb4ea0bd0167c6f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed May 1 08:32:03 2013 +0000

     xfstests: fix broken redirects in generic/131

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
