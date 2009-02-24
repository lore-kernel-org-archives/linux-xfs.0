Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OFEl9U150526 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 09:14:47 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E1698F8170
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:14:14 -0800 (PST)
Message-Id: <3C7B0B6E-1316-41CC-8846-356FDC780287@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <200902240953.56992.vapier@gentoo.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 09:14:13 -0600
References: <200902240010.25434.vapier@gentoo.org>
	<200902240221.44184.vapier@gentoo.org>
	<20090224131523.GA1579@infradead.org>
	<200902240953.56992.vapier@gentoo.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Feb 24, 2009, at 8:53 AM, Mike Frysinger wrote:

> the xfs.org wiki talks about git trees on sgi.com,

Yes, they're still there.

> but some of them are old
> and/or moved (like the xfs-cmds one) ...

xfs-cmds was split into separate repos for xfsprogs, xfsdump,
and dmapi. And that info is on xfs.org. Here is the excerpt
from the following page:

http://www.xfs.org/index.php/Getting_the_latest_source_code

XFS user space tools

     * xfsprogs

$ git clone git://oss.sgi.com/xfs/cmds/xfsprogs

XFS dump

     * xfsdump

$ git clone git://oss.sgi.com/xfs/cmds/xfsdump

XFS tests

     * xfstests

$ git clone git://oss.sgi.com/xfs/cmds/xfstests

DMAPI user space tools

     * dmapi

$ git clone git://oss.sgi.com/xfs/cmds/dmapi


At times though the repos on kernel.org could be ahead of sgi ones.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
