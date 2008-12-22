Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMKYZ0o025293 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 14:34:36 -0600
Message-ID: <494FF9B3.9030103@sgi.com>
Date: Tue, 23 Dec 2008 07:33:55 +1100
From: Mark Goodwin <markgw@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/20] xfs-cmds staging tree
References: <20081222163831.755809000@bombadil.infradead.org>
In-Reply-To: <20081222163831.755809000@bombadil.infradead.org>
Reply-To: markgw@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



Christoph Hellwig wrote:
> This is the staging tree of xfs patches.  Given that Barry is gone now it seem
> like no one cares about userspace and I'll play patch monkey for now.

Thanks Christoph. Lachlan and I were just discussing yesterday that
it's time to set up a git repository for xfs-cmds on oss. This would
contain all the userspace stuff: attr, acl, xfsprogs, dmapi, xfsdump
and xfstests.

Anyone have a reason not to keep all of this together in the one tree?
I guess we'd need branches for 'master' (aka dev) and 'stable' or 
something ..?

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
