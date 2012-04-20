Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3KH1ctI246739 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 12:01:38 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id r2jPQCuHoEAhvord for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 10:01:37 -0700 (PDT)
Message-ID: <4F919670.3090603@sandeen.net>
Date: Fri, 20 Apr 2012 12:01:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_check segfault / xfs_repair I/O error
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
	<4F917B77.6040403@sandeen.net>
	<CALcU-6i3MY+Z-dFzE5p34DSMxcQi2dPdXZHenh+=5TObyiB8eQ@mail.gmail.com>
In-Reply-To: <CALcU-6i3MY+Z-dFzE5p34DSMxcQi2dPdXZHenh+=5TObyiB8eQ@mail.gmail.com>
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
To: Drew Wareham <m3rlin@gmail.com>
Cc: xfs@oss.sgi.com

On 4/20/12 10:46 AM, Drew Wareham wrote:
> Good point!  We're running CentOS 5, so is the CentOS-Plus repo the way to go?  These servers are all setup from a fairly old base image hence using kmod-xfs, definitely something I'll address.

as long as you're on x86_64, the stock kernel has the xfs.ko you want.

I'm not big on offering too much centos support, but i would rather not see people using reaaaly crufty xfs.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
