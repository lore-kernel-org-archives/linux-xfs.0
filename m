Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JGb02O261956 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:37:01 -0500
Subject: Re: [PATCH] xfs: Check the return value of xfs_buf_get()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315424274.9298.10.camel@chandra-lucid.austin.ibm.com>
References: <1315424274.9298.10.camel@chandra-lucid.austin.ibm.com>
Date: Mon, 19 Sep 2011 11:36:55 -0500
Message-ID: <1316450215.2941.21.camel@doink>
MIME-Version: 1.0
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
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-09-07 at 14:37 -0500, Chandra Seetharaman wrote:
> Check the return value of xfs_buf_get() and fail appropriately.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
