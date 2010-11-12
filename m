Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNOaNx171606 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:24:36 -0600
Subject: Re: [PATCH v2 9/9] xfsrestore: check for compatible xfsrestore
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163644.761748638@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163644.761748638@sgi.com>
Date: Fri, 12 Nov 2010 17:25:37 -0600
Message-ID: <1289604337.2315.911.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Fri, 2010-11-05 at 11:35 -0500, wkendall@sgi.com wrote:
> plain text document attachment (check_compatible_restore)
> When resuming a restore or doing a cumulative restore, xfsrestore
> reads state information left around by the previous invocation.
> This patch adds logic to determine whether or not restore is
> able to make sense of the sense information.
> 
> The xfsrestore man page has also been updated to make the user
> aware of the requirement to use a compatible restore and
> system when resuming restores.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
