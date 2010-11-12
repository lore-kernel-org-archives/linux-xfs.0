Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACNMT8i171502 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:22:29 -0600
Subject: Re: [PATCH v2 1/9] xfsrestore: turn off NODECHK
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101105163643.135791532@sgi.com>
References: <20101105163500.747192954@sgi.com>
	<20101105163643.135791532@sgi.com>
Date: Fri, 12 Nov 2010 17:23:19 -0600
Message-ID: <1289604199.2315.895.camel@doink>
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
> The NODECHK macro should only be enabled as needed for
> development/debugging. Having it on limits xfsrestore to dumps
> with 268 million directory entries instead of 4 billion. 
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com> 

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
