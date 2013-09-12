Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41F0929E03
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:17:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B5C58F8064
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:17:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dC1sEDElL1VzdX0S for <linux-xfs@oss.sgi.com>;
	Thu, 12 Sep 2013 14:17:47 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 565BD653B1A1
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:17:47 -0500 (CDT)
Message-ID: <52322F7A.8060405@sandeen.net>
Date: Thu, 12 Sep 2013 16:17:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Time for an xfsprogs "alpha1" release?
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

With all of the changes for CRC filesystems in xfsprogs git now, I'm wondering if it'd be a good idea to do a "3.2.0-alpha1" sort of release.

I know it's not yet feature complete, but I think there would be value in getting a version-stamped tarball out there for testing - it could filter to rawhide-ish distros, and get a bit more airtime while the remaining bits get worked out.

We'd probably want a nice readme about what's new and what's not yet done, caveats, etc, but I think it'd be worth getting it out there into the hands of willing testers, w/o requiring them to do a build from git.

Thoughts?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
