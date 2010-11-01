Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1Dkuvn214900 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 08:46:57 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B64181E8AF1B
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 06:48:18 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 2Pj1AWeKWEoZnAMj
	for <xfs@oss.sgi.com>; Mon, 01 Nov 2010 06:48:18 -0700 (PDT)
Message-ID: <4CCEC51E.6060202@profihost.ag>
Date: Mon, 01 Nov 2010 14:48:14 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
References: <4CC67450.9020602@profihost.ag>	<20101026092205.086c0d89@galadriel.home>	<4CC68249.7050409@profihost.ag>
	<4CCE73C8.8070705@profihost.ag>	<20101101122751.GL2715@dastard>
	<4CCEB27E.1000605@profihost.ag>
	<20101101142933.4911a30c@galadriel.home>
In-Reply-To: <20101101142933.4911a30c@galadriel.home>
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


> Did you run the "verify" round on the array after the upgrade? That
> would rebuild all checksum and insure that the RAID is fully coherent.
> If the verify comes out with any message, there is a sloght chance that
> the data on disk wasn't entirely coherent or clean.

shure i have - was done without any problems.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
