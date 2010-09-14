Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EG8Pij134760 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:08:25 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9DF0714DE
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:09:13 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id HcGUr0Q4FIeR6Eja
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 09:09:13 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id E61D46C0B8
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 11:09:12 -0500 (CDT)
Message-ID: <4C8F9E29.2000803@hardwarefreak.com>
Date: Tue, 14 Sep 2010 11:09:13 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Filesystem not mounting
References: <29704010.post@talk.nabble.com>	<20100914082504.4109712d@galadriel.home>	<29708085.post@talk.nabble.com>
	<201009141603.24754@zmi.at>
In-Reply-To: <201009141603.24754@zmi.at>
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

Michael Monnerie put forth on 9/14/2010 9:03 AM:

> I'm currently on 11.2, and must say it's the best I ever worked with. 
> Especially upgrading is so fast, smooth and easy now (in-place upgrade) 
> that it really makes fun. Didn't have time to upgrade to 11.3, I just 
> did a fresh install of it once and it looked even better (desktop 
> version on a notebook).

I've been using Debian for headless servers for many years.
Distribution upgrades via apt-get or aptitude have been smooth and easy
for many years.  I have one server that's been in-place upgraded from
Woody through Lenny with only minor dependency issues--that's 4
distribution upgrades over 5 years--Woody, Sarge, Etch, Lenny.

Then again, I don't use Debian kernels, so my kernels were never
upgraded during the dist upgrade.  This may have prevented some
headaches.  I roll my own kernels from kernel.org source and tend to
keep fairly current.  So, when I do a dist upgrade my current kernel is
usually newer than what the dist upgrade provides.  The fact I leave out
features I don't need may play a role in preventing problems as well.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
