Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0K93jrY094228 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 03:03:45 -0600
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id oougDtBHwuSCTbJP for
	<xfs@oss.sgi.com>; Fri, 20 Jan 2012 01:03:42 -0800 (PST)
Received: from [192.168.3.140] (Athenae [192.168.3.140])
	by Ishtar.sc.tlinx.org (8.14.4/8.14.4/SuSE Linux 0.8) with ESMTP id
	q0K93dx5012076 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 01:03:41 -0800
Message-ID: <4F192DEC.4030400@tlinx.org>
Date: Fri, 20 Jan 2012 01:03:40 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Optimal XFS formatting options?
References: <33140169.post@talk.nabble.com>
	<20242.10382.19330.275280@tree.ty.sabi.co.UK>
In-Reply-To: <20242.10382.19330.275280@tree.ty.sabi.co.UK>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>



Peter Grandi wrote:
>
> 
>   * XFS has several limitations on 32b kernels. Just make sure
>     you have a 64b kernel.
----
	I was unaware that the block size was larger on 64b kernels.

Is that what you are referring to ?

(would be nice)...


One thing I have a Q on -- you (OP), said this was an 'iscsi' box?

That means hookup over an network, right?

You are planning on using a 10Gbit or faster network fabric, right?

a 1Gb ethernet will only get you 125MB/s max... doesn't take much
tuning to hit that speed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
