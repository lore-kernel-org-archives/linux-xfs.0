Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FA617F50
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 09:43:23 -0600 (CST)
Message-ID: <512CD85E.3070405@sgi.com>
Date: Tue, 26 Feb 2013 09:44:30 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfstests: Provide dumpe2fs via standard common.config
	interface
References: <1359886798-8818-1-git-send-email-tracek@redhat.com>
In-Reply-To: <1359886798-8818-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

Applied this series to xfstests.

Thanks
--Rich

commit 29fe8007e75bf8983fa1267ae2850787262f17c1
Author: Tomas Racek <tracek@redhat.com>
Date:   Tue Feb 12 09:21:59 2013 +0000

     xfstests: Add new standard loop handling functions

  commit 03b0089e9b18ee6b4e5e990db98a1f545cc2521b
Author: Tomas Racek <tracek@redhat.com>
Date:   Sun Feb 3 10:19:56 2013 +0000

     xfstests: Provide dumpe2fs via standard common.config interface

commit 76765b7e4e425dee394e12789264d6db1fea2876
Author: Tomas Racek <tracek@redhat.com>
Date:   Sun Feb 3 10:19:58 2013 +0000

     xfstests: 298: Test that FS sends discard requests only on free blocks


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
