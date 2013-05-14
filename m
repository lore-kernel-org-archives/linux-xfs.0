Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53A1B7CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 22:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D26CEAC002
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 20:17:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	puxB3LQUX39uZHBN for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 20:17:19 -0700 (PDT)
Date: Tue, 14 May 2013 13:17:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: XFS rootfs corruption
Message-ID: <20130514031717.GW24635@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<1140911111.191794.1368498503318.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1140911111.191794.1368498503318.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Mon, May 13, 2013 at 10:28:23PM -0400, CAI Qian wrote:
> 3.10-rc1 has the same problem reproduced on 2 Power 7 systems. I am going to
> get the metadata dump this time.

Of course. It's detecting an on-disk corruption, so it you haven't
fixed it the kernel will still find it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
