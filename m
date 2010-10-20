Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9KGuGvd094127 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 11:56:17 -0500
Received: from rrzmta5.rz.uni-regensburg.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27E721953754
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 09:57:29 -0700 (PDT)
Received: from rrzmta5.rz.uni-regensburg.de (rrzmta5.rz.uni-regensburg.de
	[194.94.155.56]) by cuda.sgi.com with ESMTP id PdZJbPqc7d8uvZS6
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 09:57:29 -0700 (PDT)
Received: from rrzmta5.rz.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 5FB9925CB
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 18:57:27 +0200 (CEST)
Received: from [192.168.2.100] (rgnb-4d04b4a0.pool.mediaWays.net
	[77.4.180.160])
	(using SSLv3 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client did not present a certificate)
	(Authenticated sender: haa07761)
	by rrzmta5.rz.uni-regensburg.de (Postfix) with ESMTPSA id 201D624FB
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 18:57:26 +0200 (CEST)
Subject: Re: Question/Problem: Mounting of XFS filesystem takes a lot of time
From: Andreas Hasenkopf <andreas.hasenkopf@physik.uni-regensburg.de>
Date: Wed, 20 Oct 2010 18:57:26 +0200
Message-ID: <1287593846.2338.5.camel@nukebox>
Mime-Version: 1.0
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

Hello,
thank you all for your emails with suggestions and comments on my
problem.
When messing around with the BIOS settings (switching SATA mode from
RAID to IDE) I get quite an obvious message stating that the S.M.A.R.T.
status of one of the disks is BAD.
Removing that disk solved the problem. My system is mounting the
remaining XFS partitions fast as usual.

Thanks again
Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
