Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9507D7F6C
	for <xfs@oss.sgi.com>; Mon, 30 Sep 2013 17:52:03 -0500 (CDT)
Date: Mon, 30 Sep 2013 17:52:03 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] xfs: candidate fixes for 3.12-rc4
Message-ID: <20130930225203.GR1935@sgi.com>
References: <1380497826-13474-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380497826-13474-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 30, 2013 at 09:37:02AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The first two patches are regressions and hence -rc4 candidates -
> the first patch fixes a lockdep false positive as a result of adding
> the third quota inode, and the second fixes a on-disk format
> interpretation problem in the v4 superblock dtype-in-dirent feature.

Applied 1 and 2.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
