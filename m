Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6FFV2Lc209665 for <xfs@oss.sgi.com>; Fri, 15 Jul 2011 10:31:02 -0500
Subject: Re: [PATCH] xfs: Remove the second parameter to xfs_sb_count()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309385414.5505.6282.camel@chandra-lucid.beaverton.ibm.com>
References: <1309385414.5505.6282.camel@chandra-lucid.beaverton.ibm.com>
Date: Fri, 15 Jul 2011 10:30:57 -0500
Message-ID: <1310743857.2921.18.camel@doink>
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

On Wed, 2011-06-29 at 15:10 -0700, Chandra Seetharaman wrote:
> Remove the second parameter to xfs_sb_count() since all callers of the
> function set them.
> 
> Also, fix the header comment regarding it being called periodically.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
