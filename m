Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKAIN0j106735 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 04:18:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFC051CDEACC
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 02:20:18 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id ik0vnfaBgKbM6pMB for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 02:20:18 -0800 (PST)
Date: Mon, 20 Dec 2010 05:20:18 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Question regarding xfs_repair / memory requirement.
Message-ID: <alpine.DEB.2.00.1012200519230.26485@p34.internal.lan>
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
To: xfs@oss.sgi.com

Hi,

I am looking at FS to use for a possible 43TB array.
If there is a problem with a volume this large, how much ram will 
xfs_repair need to fsck the volume?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
