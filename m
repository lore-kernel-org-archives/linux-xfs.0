Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8F3p43w163641 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 22:51:05 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53CB5DDE8E8
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 21:03:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hA8XLA30fxiWBHQB
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 21:03:41 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id C921A6C04C
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 22:51:51 -0500 (CDT)
Message-ID: <4C9042D7.90001@hardwarefreak.com>
Date: Tue, 14 Sep 2010 22:51:51 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Now: Debian issues, WAS: XFS Filesystem not mounting
References: <29704010.post@talk.nabble.com>
	<20100914012151.GF411@dastard>	<29705139.post@talk.nabble.com>
	<201009140740.14482@zmi.at>	<20100914082504.4109712d@galadriel.home>	<29708085.post@talk.nabble.com>
	<201009141603.24754@zmi.at>	<4C8F9E29.2000803@hardwarefreak.com>	<29710491.post@talk.nabble.com>	<4C8FB8D6.6080603@hardwarefreak.com>	<20100914223201.21c3bd0f@galadriel.home>
	<29714426.post@talk.nabble.com>
In-Reply-To: <29714426.post@talk.nabble.com>
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

pbrunnen put forth on 9/14/2010 8:07 PM:

> Always was intrigued by the SGI equipment in the labs when I was at
> University...  Never played with one though.  Checked out the specs of those
> Origin boxes you mention.  That was some horsepower for the time.

Some years ago NCSA was selling off some retired 128P O2K systems really
really cheap.  I was only about 4 hours away from Urbana Champaign at
the time and was really tempted.  I was planning on running _lots_ of
seti@home processes on it, mainly.  ;)

The price was really decent for what I'd be getting, but in the end I
just couldn't justify it, no matter how cool it would have been to have
a dual rack 32P SGI Origin 2000 running in the basement, crunching S@H.

The reality check was that I could build a new 4U quad Xeon box at the
time, of about the same overall performance, and with lots more disk,
for a mere fraction of the cost of the used O2K.  It wouldn't have the
cool SGI badge or run IRIX, but I wouldn't have to add 220v circuits in
the basement, or acquire a big 220v UPS, or pay a much larger monthly
electric bill.

A single socket 12-core 2 GHz Opteron 6100 series on a SuperMicro mobo
with quad DDR3 memory channels w/32 GB RAM, sitting on your desktop,
would simply run circles around that old 2 rack 32P O2K system, probably
5 to 1 or greater in parallel linpack--for less than $2k.

-- 
Stan



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
