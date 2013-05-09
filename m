Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC7E529DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 07:41:46 -0500 (CDT)
Message-ID: <518B999B.1000403@sgi.com>
Date: Thu, 9 May 2013 07:42:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
References: <20130412145555.GF30622@dastard>
In-Reply-To: <20130412145555.GF30622@dastard>
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

Dave,

The following have been committed:

logprint-agi-dump
xfs-fsr-odirect-read
xfsprogs-remove-dirv1-support
xfsprogs-kernel-3.8-update
xfsprogs-kernel-3.9-rc1-dev-update

Thanks
--Rich

commit 49f693fa26783bb95136cdb3479902324be3f587
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 9 07:24:15 2013 -0500

     xfsprogs: update libxfs to 3.9-rc1 + xfsdev

commit a2ceac1f6dd8771fc1cd993a6cffc30589af1ddc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 9 07:23:15 2013 -0500

     xfsprogs: sync code to current kernel code

commit 9a048535fceee3d199978f31524bfd649edaff08
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 9 07:22:15 2013 -0500

     xfsprogs: Die dir1 Die!

commit 108e985bc596a1f1a33d31a348fdb430213fb8c0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 9 07:16:09 2013 -0500

     xfs_fsr: file reads should be O_DIRECT

commit a59111c1fc89a8bb5bd1030efce8b75f583e9b1e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 9 07:11:50 2013 -0500

     xfs_logprint: print all AGI unlinked buckets

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
