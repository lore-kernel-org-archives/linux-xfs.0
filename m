Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11K9msU237756 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 14:09:48 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACADF162A3C4
	for <xfs@oss.sgi.com>; Tue,  1 Feb 2011 12:12:15 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fSqcxjuxPj013LP2
	for <xfs@oss.sgi.com>; Tue, 01 Feb 2011 12:12:15 -0800 (PST)
Message-ID: <4D48691C.8000006@hardwarefreak.com>
Date: Tue, 01 Feb 2011 14:12:12 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Preallocation
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>	<20110128045205.GR21311@dastard>	<155CAEA5D902E7429569DD197567724A01534D60@mail1.ad.kinetx.com>	<20110129001700.GZ21311@dastard>	<3F5ACD12257C714E9C0535D0A839171802A9B4@SC-MBX02-2.TheFacebook.com>	<20110201080354.GM11040@dastard>
	<3F5ACD12257C714E9C0535D0A839171802AB01@SC-MBX02-2.TheFacebook.com>
In-Reply-To: <3F5ACD12257C714E9C0535D0A839171802AB01@SC-MBX02-2.TheFacebook.com>
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
To: Peter Vajgel <pv@fb.com>
Cc: Jef Fox <jef.fox@kinetx.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Peter Vajgel put forth on 2/1/2011 1:20 PM:

> At the scale we operate it does. We have multiple variables so the number of combinations is large. We have hit every single possible hardware and software problem and problem resolution can take months if it takes days to reproduce the problem. Hardware vendors (disk, controller, motherboard manufacturers) are much more responsive when you can reproduce a problem on the fly in seconds (especially in comparative benchmarking). The tests usually run only couple of minutes. With 12x3TB (possibly multiplied by a factor of X with our new platform) it would be unacceptable to wait for writes to finish.

Hi Peter,

When you mention scale, you're referring to the storage back end at
facebook.com, your employer, correct?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
