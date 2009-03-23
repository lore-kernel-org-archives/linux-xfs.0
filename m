Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2NIX9K3177619
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 13:33:31 -0500
Received: from uplift.swm.pp.se (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7B8D13C02E1
	for <linux-xfs@oss.sgi.com>; Mon, 23 Mar 2009 11:32:36 -0700 (PDT)
Received: from uplift.swm.pp.se (swm.pp.se [212.247.200.143]) by cuda.sgi.com
	with ESMTP id NKoFNBXdxeYuyU61 for <linux-xfs@oss.sgi.com>;
	Mon, 23 Mar 2009 11:32:36 -0700 (PDT)
Date: Mon, 23 Mar 2009 19:32:28 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How to configure 36 disks ?
In-Reply-To: <87f94c370903230945k66a804a0iefbb76dd9c93fc16@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903231930000.25843@uplift.swm.pp.se>
References: <49C7AC2C.9090307@tmr.com>
	<174852.24274.qm@web51309.mail.re2.yahoo.com>
	<87f94c370903230945k66a804a0iefbb76dd9c93fc16@mail.gmail.com>
MIME-Version: 1.0
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
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Jon@ehardcastle.com, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-aio@kvack.org, linux-xfs@oss.sgi.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Raz <raziebe@gmail.com>, linux-fsdevel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>

On Mon, 23 Mar 2009, Greg Freemyer wrote:

> http://www.pc-pitstop.com/sata_enclosures/sat122urd.asp
> http://www.pc-pitstop.com/sata_enclosures/scsas16rm.asp

I would like to add this if you're on a budget:

<http://cgi.ebay.com/NORCO-RPC-4020-4u-rack-mountable-case-no-power-supply_W0QQitemZ380111981091QQcmdZViewItemQQptZCOMP_EN_Servers?hash=item380111981091&_trksid=p3286.c0.m14&_trkparms=72%3A1205|66%3A4|65%3A12|39%3A1|240%3A1318|301%3A1|293%3A1|294%3A200>

> sata ports in the PC to control the 36 drives.  Not sure what the limits 
> of PMP is, but 4x seems reasonable to me.

The PMPs I've seen take 5 drives each:

<http://www.addonics.com/products/host_controller/ad5sapm.asp>

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
