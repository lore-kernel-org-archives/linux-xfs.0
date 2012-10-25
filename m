Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PFDIcF127438 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 10:13:19 -0500
Received: from whiskey.americas.sgi.com (eagdhcp-232-197.americas.sgi.com
	[128.162.232.197])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E751AC007
	for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 08:15:01 -0700 (PDT)
Date: Thu, 25 Oct 2012 10:15:01 -0500
From: Ben Myers <bpm@sgi.com>
Subject: status of userspace release
Message-ID: <20121025151501.GV1377@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Folks,

We're working toward a userspace release this month.  There are several patches
that need to go in first, including backing out the xfsdump format version bump
from Eric, fixes for the makefiles from Mike, and the Polish language update
for xfsdump from Jakub.  If anyone knows of something else we need, now is the
time to flame about it.  I will take a look around for other important patches
too.

This time I'm going to tag an -rc1 (probably later today or tomorrow).  We'll
give everyone a few working days to do a final test and/or pipe up if we have
missed something important.  Then if all goes well we'll cut the release next
Tuesday.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
