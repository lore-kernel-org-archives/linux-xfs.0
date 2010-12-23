Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNI4CTi216845 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 12:04:13 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07DDB21C326
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 10:06:10 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id mTrdWkeF9YfLAEMs for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 10:06:10 -0800 (PST)
Date: Thu, 23 Dec 2010 13:06:10 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
In-Reply-To: <alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1012231304130.12482@p34.internal.lan>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
	<4D124B71.9030401@sandeen.net>
	<20101223012655.2681c596@galadriel.home>
	<alpine.DEB.2.00.1012221928050.7452@p34.internal.lan>
	<20101223005630.GJ4907@dastard>
	<alpine.DEB.2.00.1012230442150.7452@p34.internal.lan>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com


On Thu, 23 Dec 2010, Justin Piszcz wrote:


Hi,

How come parted using (optimal at 1mb alignment is slower than no 
partition?  In addition, sunit and swidth set properly as mentioned earlier
appears to be _slower_ than defaults with no partitions.


http://home.comcast.net/~jpiszcz/20101223/final.html

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
