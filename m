Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFEAD7F3F
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 12:26:03 -0500 (CDT)
Date: Wed, 26 Jun 2013 12:25:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: Remove the left function variable from
	xfs_ialloc_get_rec()
Message-ID: <20130626172559.GJ20932@sgi.com>
References: <51C7DB13.9050204@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C7DB13.9050204@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 24, 2013 at 01:37:23PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> This patch clean out the left function variable as it is
> useless to xfs_ialloc_get_rec().
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
