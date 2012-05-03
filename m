Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43Co2tm164270 for <xfs@oss.sgi.com>; Thu, 3 May 2012 07:50:02 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id tCrGFlgrCUktD878
	for <xfs@oss.sgi.com>; Thu, 03 May 2012 05:50:00 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id F0A5F6C105
	for <xfs@oss.sgi.com>; Thu,  3 May 2012 07:49:59 -0500 (CDT)
Message-ID: <4FA27EF8.6040002@hardwarefreak.com>
Date: Thu, 03 May 2012 07:50:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Storage server, hung tasks and tracebacks
References: <20120502184450.GA2557@nsrc.org>
In-Reply-To: <20120502184450.GA2557@nsrc.org>
Reply-To: stan@hardwarefreak.com
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
To: xfs@oss.sgi.com

On 5/2/2012 1:44 PM, Brian Candler wrote:
> I have a really wierd problem with storage. The one thing that I *can* see
> is dmesg output giving messages about hung tasks and XFS call tracebacks, so
> I'm posting here in the hope that someone can help me interpret them - even
> if only to say "this definitely means that your disks are not responding"
> would be very helpful.
...
> Any other suggestions (and of course interpretation of the kernel call
> tracebacks) would be much appreciated.

Which mainboards are these Brian?  Make/model?

Make/model/count of all add in cards?

Make/model of PSU?

Make model of chassis?

I'll sleuth around and see what I can find.  Could be some obscure
expansion card interaction.  Could be undersized PSUs or lack of
backplanes spread evenly across the 12v rails of a multi-rail PSU, etc, etc.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
