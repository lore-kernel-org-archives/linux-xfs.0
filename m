Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24C7Neg164997 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 06:07:24 -0600
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5F94218033
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 04:08:51 -0800 (PST)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id DDE3k40k3Ra544Gx
	for <xfs@oss.sgi.com>; Thu, 04 Mar 2010 04:08:51 -0800 (PST)
Message-ID: <4B8FA2CD.6010904@dermichi.com>
Date: Thu, 04 Mar 2010 13:08:45 +0100
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: XFS hang during xfs_fsr run
References: <4B8F871C.60802@dermichi.com>
	<20100304112018.GG14317@discord.disaster>
In-Reply-To: <20100304112018.GG14317@discord.disaster>
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
Cc: xfs@oss.sgi.com

Hi Dave!
> Can you run the trace through ksymoops so that we get function names
> rather than numbers that don't mean anything?
I've never done that before. Could you point me to an howto about this?

> Also, can you tell us what kernel version and distro you are
> running, as well as the version of xfs_fsr? These will help tell us
> if it is a new or known problem.
The Kernel version is 2.6.33 vanilla (self-compiled), Distro is Gentoo 
Linux, xfs_fsr Version is 3.1.1 (also self-compiled).

Please let me know if you need anything else.

thanks,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
