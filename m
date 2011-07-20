Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6K9mB5S223301 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 04:48:12 -0500
Received: from sour.ops.eusc.inter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 638C482BC9
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 02:48:10 -0700 (PDT)
Received: from sour.ops.eusc.inter.net (sour.ops.eusc.inter.net
	[84.23.254.154]) by cuda.sgi.com with ESMTP id PWRpk3JqQW5H3kaE
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 02:48:10 -0700 (PDT)
Received: from sour.ops.eusc.inter.net ([10.154.10.22] helo=localhost)
	by sour.ops.eusc.inter.net with esmtpsa (Exim 4.72)
	id 1QjTNx-000EEt-Ku
	for xfs@oss.sgi.com; Wed, 20 Jul 2011 11:48:09 +0200
Message-ID: <4E26A458.6000103@koeln.de>
Date: Wed, 20 Jul 2011 11:48:08 +0200
From: Markus Uckelmann <markus.uckelmann@koeln.de>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected. Shutting down filesystem
References: <4E254C6E.4090408@koeln.de> <20110719113847.GP30254@dastard>
In-Reply-To: <20110719113847.GP30254@dastard>
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

Am 19.07.2011 13:38, schrieb Dave Chinner:

Hi Dave,

> The main causes of this problem were fixed some time ago, but after
> 2.6.26 was released. IIRC it was in the 2.6.29-30 time frame.
> Upgrade your kernel....

Thanks a lot. One more reason to get this box up-to-date ;)

Cheers,
	
	Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
