Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08C197F8E
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 14:59:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 824FBAC013
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 12:59:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id C6w7exS2Vhbk7BvM for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 12:59:07 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 00/19] xfs: remove a bunch of unused function args
Date: Mon,  7 Apr 2014 14:58:47 -0500
Message-Id: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I did some mindless work during a plane ride.  ;)

If the granularity of these patches is just too much, I could certainly
collapse them into fewer, bigger patches, but I figured that this would
make them super-trivial to review.

Most have no interesting commit messages aside from the subject, because
the subject says it all.

Compile-tested only, TBH.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
