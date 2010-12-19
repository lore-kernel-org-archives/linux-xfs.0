Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBJEZvIo228290 for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 08:35:57 -0600
Received: from sam.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85CDC1CDD282
	for <xfs@oss.sgi.com>; Sun, 19 Dec 2010 06:37:47 -0800 (PST)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id C270PbBkab21QHCD for
	<xfs@oss.sgi.com>; Sun, 19 Dec 2010 06:37:47 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.69)
	(envelope-from <lists@nabble.com>) id 1PUKOQ-0001hs-Dt
	for xfs@oss.sgi.com; Sun, 19 Dec 2010 06:37:46 -0800
Message-ID: <30492876.post@talk.nabble.com>
Date: Sun, 19 Dec 2010 06:37:46 -0800 (PST)
From: johahoff <jh@not-dark-yet.de>
Subject: Re: Fwd: xfs - fixing wrong xfs size
In-Reply-To: <4CE15F39.2010904@sandeen.net>
MIME-Version: 1.0
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
	<49E353FD.5060207@sandeen.net>
	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
	<4BE1EF9D.2030901@sandeen.net> <30211747.post@talk.nabble.com>
	<4CE15F39.2010904@sandeen.net>
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


That worked perfectly, thanks a lot, Eric!

One minor issue: I had to use 'xfs_db -x', not '-w', but probably that's
because of an old version of xfs-utils on the SystemRescueCD I was using.
Just a hint if anybody is wondering.

Thanks again,
Johannes
-- 
View this message in context: http://old.nabble.com/xfs---fixing-wrong-xfs-size-tp23023562p30492876.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
