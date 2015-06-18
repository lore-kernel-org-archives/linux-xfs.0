Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 041587F6B
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 09:59:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C57F18F8052
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 07:59:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4y0QgdZXK0lxXcFa for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 07:59:39 -0700 (PDT)
Message-ID: <5582DCDA.9070200@sandeen.net>
Date: Thu, 18 Jun 2015 09:59:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
	xfs_dir2_sf_get_parent_ino+0xa/0x20
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>	<20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
In-Reply-To: <CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
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
To: Kuo Hugo <tonytkdk@gmail.com>, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Hugo Kuo <hugo@swiftstack.com>, darrell@swiftstack.com

On 6/18/15 9:29 AM, Kuo Hugo wrote:
>>- Have you tried an 'xfs_repair -n' of the affected filesystem? Note that -n will report problems only and prevent any modification by repair.
> 
> *We might to to xfs_repair if we can address which disk causes the issue. *

If you do, please save the output, and if it finds anything, please provide the output in this thread.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
