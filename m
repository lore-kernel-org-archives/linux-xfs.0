Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14GTDPp161607 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 10:29:14 -0600
Received: from can12.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40E071BB66AA
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 08:28:34 -0800 (PST)
Received: from can12.de (can12.de [213.203.199.141]) by cuda.sgi.com with
	ESMTP id QAog0JkS95OIqO34 for <xfs@oss.sgi.com>;
	Wed, 04 Feb 2009 08:28:34 -0800 (PST)
Received: from [192.168.0.2] (p54AAE5F5.dip.t-dialin.net [84.170.229.245])
	by can12.de (can12.de) with ESMTP id 18F4E2B4FCF
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 17:28:05 +0100 (CET)
Message-Id: <4D4B8415-C82D-4A23-9A08-F06A67DC92BA@hal-9k.de>
From: Julian Einwag <julian@hal-9k.de>
In-Reply-To: <4980A4BB.9050502@thebarn.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XFS trouble: task xfssyncd blocked for more than 120 seconds.
Date: Wed, 4 Feb 2009 17:27:59 +0100
References: <A22069E0-B39A-41CF-9467-4524055B1970@hal-9k.de>
	<4980A4BB.9050502@thebarn.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi!

Am 28.01.2009 um 19:32 schrieb Russell Cattelan:

> Could get a call trace of all process the next time this happens?
>
> srq-t
>
> That would help us to see what else is going on and what might be
> holding things up.


Just wanted to give a quick feedback here: We recently did an upgrade  
to Kernel 2.6.28.3 and things have been running smoothly so far, so  
we're hoping that the problem is gone.

Best regards,
Julian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
