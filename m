Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5BDF7F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 08:05:34 -0500 (CDT)
Message-ID: <51ED2E1E.5080407@sgi.com>
Date: Mon, 22 Jul 2013 08:05:34 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 35/49] xfs: Introduce a new structure to hold transaction
	reservation items
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-36-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-36-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Introduce a new structure xfs_trans_res to hold transaction
> reservation item info per log ticket.
>
> We also need to improve xfs_trans_resv_calc() by initializing the
> log count as well as log flags for permanent log reservation.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
