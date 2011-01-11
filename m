Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0B8AG0Q076714 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 02:10:17 -0600
Received: from bork.lsof.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4477FD07AB
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 00:12:27 -0800 (PST)
Received: from bork.lsof.org (bork.lsof.org [87.253.148.42]) by cuda.sgi.com
	with ESMTP id SWHXhVK1cLqL4HLS for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 00:12:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id BB251BB1E
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:12:26 +0100 (CET)
Received: from bork.lsof.org ([127.0.0.1])
	by localhost (bork.lsof.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rIuABDFXxAep for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 09:12:24 +0100 (CET)
Received: from bork.lsof.org (localhost [127.0.0.1])
	by bork.lsof.org (Postfix) with ESMTP id BBB1FB8D0
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 09:12:24 +0100 (CET)
Message-ID: <cone.1294733544.730446.31666.1001@bork.lsof.org>
From: Roel van Meer <roel.vanmeer@bokxing.nl>
Subject: XFS defaults in FAQ on kernel.org
Date: Tue, 11 Jan 2011 09:12:24 +0100
Mime-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi list,

Seeing how many people are using unnecessary defaults for xfs, perhaps 
someone can mail the kernel.org guys to fix their FAQ item on XFS:

Filesystem: xfs, mounted with "rw,noatime,nodiratime,nobarrier,logbsize=256k".

(Found here: http://www.kernel.org/faq/#howdoesitwork )

I'm not sure how many people will look there for XFS info, but kernel.org 
might seem trustworthy enough for some people to blindly use this info, so 
we better make sure it's correct.

Regards,

Roel (helping Dave running a sed script across the internet)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
