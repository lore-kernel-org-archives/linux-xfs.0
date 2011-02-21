Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1LNUsvv183200 for <xfs@oss.sgi.com>; Mon, 21 Feb 2011 17:30:54 -0600
Subject: Re: [PATCH] xfstests: Notify via syslog when godown is shutting
	down fs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4D5C554D.8080004@sandeen.net>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>  <4D5C554D.8080004@sandeen.net>
Date: Mon, 21 Feb 2011 17:30:00 -0600
Message-ID: <1298331000.2169.4.camel@doink>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Wed, 2011-02-16 at 16:53 -0600, Eric Sandeen wrote:
> Just a hint for those perusing logs that the ensuing shutdown is
> intentional...

Good idea.

Signed-off-by: Alex Elder <aelder@sgi.com>

> Feb 16 17:06:17 hostname godown: xfstests-induced forced shutdown of /mnt/scratch
> Feb 16 17:06:17 hostname kernel: Filesystem "sdb3": xfs_log_force: error 5 returned.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
