Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PJJPJH180907 for <xfs@oss.sgi.com>; Fri, 25 May 2012 14:19:25 -0500
Date: Fri, 25 May 2012 14:24:46 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RESEND PATCH] xfs: fix typo in comment of xfs_dinode_t.
Message-ID: <20120525192445.GW16099@sgi.com>
References: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D347A332-0256-43E4-8FCE-BCFC1DD478C8@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Chen Baozi <baozich@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sat, May 26, 2012 at 12:48:47AM +0800, Chen Baozi wrote:
> There should be "XFS_DFORK_DPTR, XFS_DFORK_APTR, and XFS_DFORK_PTR" instead
> of "XFS_DFORK_PTR, XFS_DFORK_DPTR, and XFS_DFORK_PTR".
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>

Committed.  Thanks for the patch Chen!

Signed-off-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
