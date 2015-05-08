Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF1587F54
	for <xfs@oss.sgi.com>; Fri,  8 May 2015 16:14:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D6A3AC003
	for <xfs@oss.sgi.com>; Fri,  8 May 2015 14:14:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id bXdvmFjHX4VjC6YY for <xfs@oss.sgi.com>;
	Fri, 08 May 2015 14:14:42 -0700 (PDT)
Message-ID: <554D2741.5060906@sandeen.net>
Date: Fri, 08 May 2015 16:14:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: Add new sb_meta_uuid field, and userspace
	tools to manipulate it
References: <554D1F56.7030209@redhat.com> <554D23B2.4030103@sandeen.net>
In-Reply-To: <554D23B2.4030103@sandeen.net>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Of course, just ran into a problem w/ mkfs not initializing stuff right, not sure why the first 25 xfstests were happy.

Will send V2 for userspace, split into libxfs & tools updates, and that fix.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
