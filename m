Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP8GkKp022638 for <xfs@oss.sgi.com>; Tue, 25 Nov 2008 02:16:47 -0600
Date: Tue, 25 Nov 2008 03:16:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081125081644.GA20644@infradead.org>
References: <492BA7AD.5080007@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492BA7AD.5080007@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
> There's a few branches there already:
> 
> 'master'      This will contain all the latest xfs changes not yet pushed
>                to mainline.
> 'mainline'    This is vanilla mainline and will updated regularly.
> 'for-linus'   Our staging branch for pull requests
> 'xfs-dev'     This branch will contain KDB and other supporting code for
>                development and should be identical to the old CVS tree.
> 
> Feel free to start using it and let us know if you have any issues.

Any chance to have these as separate git trees instead of branches?

In either case, do you expect patches against the xfs-dev or the master
tree?  It would also be useful if the trees and which one to be used
could be documented on oss.sgi.com/projects/xfs or xfs.org.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
