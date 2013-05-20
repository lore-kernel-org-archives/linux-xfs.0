Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8DA67F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 14:38:02 -0500 (CDT)
Date: Mon, 20 May 2013 14:37:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 00/14] xfs: fixes for 3.10-rc2 (update)
Message-ID: <20130520193759.GB20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-1-git-send-email-david@fromorbit.com>
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

On Mon, May 20, 2013 at 09:51:07AM +1000, Dave Chinner wrote:
> THis is my current patch queue for 3.10-rc2. It contains the same first 6
> patches as posted here:
> 
> http://oss.sgi.com/pipermail/xfs/2013-May/026366.html
> 
> This update adds another 8 patches that fix attribute bugs on CRC
> enabled filesystems. These patches make the attr group in xfstests
> pass rather than assert fail or oops.

Applied 1-3.  Will work on reviews for the others.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
