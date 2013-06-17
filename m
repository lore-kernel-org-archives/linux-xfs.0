Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EFEF29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:55:01 -0500 (CDT)
Date: Mon, 17 Jun 2013 17:55:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfs: Remove struct xfs_chash from xfs_mount
Message-ID: <20130617225500.GL20932@sgi.com>
References: <51824CA8.9000209@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51824CA8.9000209@oracle.com>
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
Cc: Dave Chinner <dchinner@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 02, 2013 at 07:23:20PM +0800, Jeff Liu wrote:
> v2->v1:
> Fix a typo at comments, i.e. s/xfs_krash/xfs_chash/.
> 
> 
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Remove struct xfs_chash from struct xfs_mount as there is no user of
> it nowadays.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
